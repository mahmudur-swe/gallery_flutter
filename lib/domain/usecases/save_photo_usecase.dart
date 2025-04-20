
import '../repositories/photo_repository.dart';

class SavePhotoUseCase {

  final PhotoRepository _photoRepository;

  SavePhotoUseCase(this._photoRepository);

  Future<bool> execute(String uri) async {
    return _photoRepository.savePhoto(uri);
  }
}