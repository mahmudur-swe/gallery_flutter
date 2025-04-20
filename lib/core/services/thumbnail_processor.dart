import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:gallery_flutter/core/services/photo_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';

import '../util/log.dart';
import 'memory_service.dart';

const double memoryFractionForCache = 0.02; // 2% of total RAM
const int avgLowResSizeBytes = 900; // 0.9 KB
const int avgHighResSizeBytes = 9000; // 9 KB

abstract class ThumbnailProcessor {
  Future<Uint8List?> loadThumbnail(
    String uri, {
    ThumbnailResolution resolution = ThumbnailResolution.high,
  });

  Future<void> init();

  void clearCache();
}

enum ThumbnailResolution {
  low, // e.g., 25x25
  high, // e.g., 300x300
}

class ThumbnailProcessorImpl implements ThumbnailProcessor {
  final PhotoService _photoService;

  ThumbnailProcessorImpl(this._photoService);

  late LruMap<String, Uint8List> _lowResCache;
  late LruMap<String, Uint8List> _highResCache;

  // var _lowResCache = LruMap<String, Uint8List>(
  //   maximumSize: 1000,
  // );
  //
  // var _highResCache = LruMap<String, Uint8List>(
  //   maximumSize: 50,
  // );

  @override
  Future<void> init() async {

    try {

      Log.debug("ThumbnailProcessor: Initializing for cache");

      final memoryMB = await MemoryInfoService.getTotalMemoryMB();

      const double cacheFraction = 0.01; // use 1% of total memory for cache
      final int totalCacheBytes = (memoryMB * 1024 * 1024 * cacheFraction).toInt();

      Log.debug('Device Memory: ${memoryMB}MB → App max memory Cache: ${totalCacheBytes ~/ 1024}KB');

      const int avgLowResBytes = 2*1024;   // low res image size aprox 1 KB to 2 KB. Safety take 2KB
      const int avgHighResBytes = 20*1024; // righ res image size aprox 10 KB to 20 KB. Safety take 20KB

      Log.debug('Average Low Res Image: ${memoryMB}MB → Low-res cache: ${avgLowResBytes}B, High-res: ${avgHighResBytes}B');

      final int lowResBudget = (totalCacheBytes * 0.7).toInt();
      final int highResBudget = totalCacheBytes - lowResBudget;

      final int lowResEntries = lowResBudget ~/ avgLowResBytes;
      final int highResEntries = highResBudget ~/ avgHighResBytes;

      Log.debug('Low-res cache: $lowResEntries entries, High-res: $highResEntries entries');

      _lowResCache = LruMap(maximumSize: Math.max(lowResEntries, 300));
      _highResCache = LruMap(maximumSize: Math.max(highResEntries, 20));

      Log.debug("ThumbnailProcessor: Cache initialized successfully");

    } catch (e) {
      _lowResCache = LruMap(maximumSize: 300);
      _highResCache = LruMap(maximumSize: 20);

      Log.error("ThumbnailProcessor: Error initializing cache: $e. Using default cache size");
    }

  }



  @override
  Future<Uint8List?> loadThumbnail(
    String uri, {
    ThumbnailResolution resolution = ThumbnailResolution.high,
  }) async {
    final cache = _getCache(resolution);
    final key = uri;

    //1. Return from cache if present
    if (cache.containsKey(key)) return cache[key];

    try {

      // 2. Read from disk if present
      final diskPath = await _getThumbnailDiskPath(uri, resolution);
      final diskFile = File(diskPath);
      if (await diskFile.exists()) {
        final bytes = await diskFile.readAsBytes();
        cache[key] = bytes;

        return bytes;
      }

      // 3. Native call to get thumbnail
      final bytes = await _photoService.getThumbnailImageBytes(
        uri,
        resolution: resolution,
      );

    if (bytes != null) {
        cache[key] = bytes;

        await File(diskPath).writeAsBytes(bytes, flush: true);



        return bytes;
      }

      return null;
    } catch (e) {
      Log.error('ThumbnailProcessor: Error loading thumbnail for $uri - $e');
      return null;
    }
  }

  @override
  void clearCache() {
    _lowResCache.clear();
    _highResCache.clear();
    clearDiskCache();
  }

  Map<String, Uint8List> _getCache(ThumbnailResolution resolution) {
    return resolution == ThumbnailResolution.low ? _lowResCache : _highResCache;
  }

  Future<String> _getThumbnailDiskPath(String uri, ThumbnailResolution resolution) async {
    final dir = await getTemporaryDirectory();
    final folder = '${dir.path}/thumbs/${resolution.name}';
    final key = sha1.convert(utf8.encode(uri)).toString();
    final path = '$folder/$key.jpg';

    final folderDir = Directory(folder);
    if (!await folderDir.exists()) {
      await folderDir.create(recursive: true);
    }
    return path;
  }

  Future<void> clearDiskCache() async {
    final dir = await getTemporaryDirectory();
    final thumbsDir = Directory('${dir.path}/thumbs');
    if (await thumbsDir.exists()) {
      await thumbsDir.delete(recursive: true);
    }
  }

}
