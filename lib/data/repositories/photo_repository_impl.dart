import 'package:gallery_flutter/data/models/photo_response.dart';

import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/photo_local_data_source.dart';

class PhotoRepositoryImpl extends PhotoRepository {

  final PhotoLocalDataSource _photoLocalDataSource;

  PhotoRepositoryImpl(this._photoLocalDataSource);

  @override
  Future<List<Photo>> getPhotos() async {

    return  _photoLocalDataSource.fetchPhotos().then(
          (models) => models.map((e) => e.toDomain()).toList(),
    );

  }

  @override
  Future<bool> savePhoto(String uri) async {

    var photoData = await _photoLocalDataSource.getFullFrameImage(uri);

    return _photoLocalDataSource.savePhoto(photoData);

  }
}
