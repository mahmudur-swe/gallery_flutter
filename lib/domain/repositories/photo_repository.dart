

import '../entities/photo.dart';

abstract class PhotoRepository {

  Future<List<Photo>> getPhotos();

  Future<bool> savePhoto(String uri);

}