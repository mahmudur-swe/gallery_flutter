import 'dart:typed_data';

import 'package:gallery_flutter/core/services/photo_services.dart';
import 'package:quiver/collection.dart';

abstract class ThumbnailProcessor {
  Future<Uint8List?> loadThumbnail(
    String uri, {
    ThumbnailResolution resolution = ThumbnailResolution.high,
  });

  void clearCache();
}

enum ThumbnailResolution {
  low, // e.g., 30x30
  high, // e.g., 300x300
}

class ThumbnailProcessorImpl implements ThumbnailProcessor {
  final PhotoService _photoService;

  ThumbnailProcessorImpl(this._photoService);

  final _lowResCache = LruMap<String, Uint8List>(
    maximumSize: 1000,
  );
  final _highResCache = LruMap<String, Uint8List>(
    maximumSize: 50,
  );

  @override
  Future<Uint8List?> loadThumbnail(
    String uri, {
    ThumbnailResolution resolution = ThumbnailResolution.high,
  }) async {
    final cache = _getCache(resolution);
    final key = uri;

    // ✅ Return from cache if present
    if (cache.containsKey(key)) return cache[key];

    try {
      final bytes = await _photoService.getThumbnailImageBytes(
        uri,
        resolution: resolution,
      );

      if (bytes != null) {
        cache[key] = bytes;
        return bytes;
      }

      return null;
    } catch (e) {
      print('ThumbnailProcessor: Error loading thumbnail for $uri - $e');
      return null;
    }
  }

  @override
  void clearCache() {
    _lowResCache.clear();
    _highResCache.clear();
  }

  Map<String, Uint8List> _getCache(ThumbnailResolution resolution) {
    return resolution == ThumbnailResolution.low ? _lowResCache : _highResCache;
  }
}
