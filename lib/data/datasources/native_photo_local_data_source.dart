

import 'package:flutter/services.dart';
import 'package:gallery_flutter/data/datasources/photo_local_data_source.dart';

import '../../core/services/photo_services.dart';
import '../models/photo_response.dart';

class NativePhotoLocalDataSource implements PhotoLocalDataSource {

  final PhotoService _photoService;

  NativePhotoLocalDataSource(this._photoService);

  @override
  Future<List<PhotoModel>> fetchPhotos() async {
    final mediaList = await _photoService.fetchPhotos();
    return mediaList.map((e) => PhotoModel.fromMap(e)).toList();
  }

  @override
  Future<bool> savePhoto(Uint8List? photoData) async {

    if(photoData == null) {
      return false;
    }

    final result = await _photoService.savePhoto( photoData);

    return result;

  }

  @override
  Future<Uint8List?> loadPhoto(String uri) async {
    return  _photoService.getFullFrameImage(uri);

  }
}