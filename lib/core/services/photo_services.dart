import 'package:flutter/services.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';

import '../constants/method_channel_constants.dart';
import '../util/log.dart';

class PhotoService {
  static const MethodChannel _channel = MethodChannel(
    MethodChannelConstants.photoChannel,
  );

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

  Future<Uint8List?> getThumbnailImageBytes(String uri, {ThumbnailResolution resolution = ThumbnailResolution.high}) async {
    try {
      final result = await _channel.invokeMethod(
        MethodChannelConstants.getThumbnailBytesMethod,
        {'uri': uri, 'resolution': resolution.name}
      );

      if (result == null) return null;

      return Uint8List.fromList(List<int>.from(result));

    } catch (e) {
      Log.error("Error loading image: $e");
      return null;
    }
  }

}
