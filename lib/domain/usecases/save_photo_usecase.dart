
import '../repositories/photo_repository.dart';

class SavePhotoUseCase {

  final PhotoRepository _photoRepository;

  SavePhotoUseCase(this._photoRepository);

  Future<bool> execute(String uri) async {
    //await Future.delayed(const Duration(milliseconds: 600)); // simulate delay
    return _photoRepository.savePhoto(uri);
  }
}