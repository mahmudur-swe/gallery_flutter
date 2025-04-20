import 'package:flutter/services.dart';
import 'package:gallery_flutter/core/services/photo_services.dart';
import 'package:gallery_flutter/data/models/photo_response.dart';


abstract class PhotoLocalDataSource {
  Future<List<PhotoModel>> fetchPhotos();
  Future<bool> savePhoto(Uint8List? photoData);
  Future<Uint8List?> loadPhoto(String uri);
}


