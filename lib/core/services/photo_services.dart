// coverage:ignore-file
import 'package:flutter/services.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';

import '../constants/method_channel_constants.dart';
import '../util/log.dart';

class PhotoService {
  static const MethodChannel _channel = MethodChannel(
    MethodChannelConstants.photoChannel,
  );

  /// Method to fetch all photos from the native platform
  Future<List<Map<String, dynamic>>> fetchPhotos() async {
    try {
      final List<dynamic> photoLists = await _channel.invokeMethod(
        MethodChannelConstants.getAllPhotosMethod,
      );

      return photoLists
          .cast<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      Log.error("Error fetching photos: $e");
      return Future.value([]);
    }
  }

  /// Method to fetch thumbnail bytes from the native platform
  Future<Uint8List?> getThumbnailImageBytes(
    String uri, {
    ThumbnailResolution resolution = ThumbnailResolution.high,
  }) async {
    try {
      final result = await _channel
          .invokeMethod(MethodChannelConstants.getThumbnailBytesMethod, {
            MethodChannelConstants.paramUri: uri,
            MethodChannelConstants.paramResolution: resolution.name,
          });

      if (result == null) return null;

      return Uint8List.fromList(List<int>.from(result));
    } catch (e) {
      Log.error("Error loading image: $e");
      return null;
    }
  }

  /// Method to fetch full frame image from the native platform
  Future<Uint8List?> getFullFrameImage(String uri) async {
    try {
      final result = await _channel.invokeMethod(
        MethodChannelConstants.getFullFrameImageMethod,
        {MethodChannelConstants.paramUri: uri},
      );

      if (result == null) return null;

      return Uint8List.fromList(List<int>.from(result));
    } catch (e) {
      Log.error("Error loading image: $e");
      return null;
    }
  }

  /// Method to save photo to the gallery
  Future<bool> savePhoto(Uint8List byteArray) async {
    try {
      final result = await _channel.invokeMethod(
        MethodChannelConstants.savePhotoMethod,
        {MethodChannelConstants.paramImageBytes: byteArray},
      );
      return result;
    } on PlatformException catch (e) {
      Log.error("Failed to save photo: '${e.message}'.");
      return false;
    }
  }
}
