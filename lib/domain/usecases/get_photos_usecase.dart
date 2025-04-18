

import 'package:gallery_flutter/domain/entities/photo.dart';

import '../repositories/photo_repository.dart';

class GetPhotosUseCase {

  final PhotoRepository _photoRepository;

  GetPhotosUseCase(this._photoRepository);

  Future<List<Photo>> execute() async {
    return _photoRepository.getPhotos();
  }
}
