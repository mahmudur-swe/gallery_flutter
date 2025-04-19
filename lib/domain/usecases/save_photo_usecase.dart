
class SavePhotoUseCase {
  Future<bool> execute(String name, String uri) async {

    await Future.delayed(const Duration(milliseconds: 600)); // simulate delay

    return true;
  }
}