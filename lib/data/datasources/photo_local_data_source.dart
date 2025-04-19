import 'package:flutter/services.dart';
import 'package:gallery_flutter/core/services/photo_services.dart';
import 'package:gallery_flutter/data/models/photo_response.dart';

import '../../core/constants/method_channel_constants.dart';


class PhotoLocalDataSource {

  final PhotoService _photoService;

  PhotoLocalDataSource(this._photoService);

  Future<List<PhotoModel>> fetchPhotos() async {
    final mediaList = await _photoService.fetchPhotos();
    return mediaList.map((e) => PhotoModel.fromMap(e)).toList();
  }

  Future<bool> savePhoto(Uint8List? photoData) async {

    if(photoData == null) {
      return false;
    }

    final result = await _photoService.savePhoto( photoData);

    return result;

  }

  Future<Uint8List?> getFullFrameImage(String uri) async {
    return  _photoService.getFullFrameImage(uri);

  }
}
