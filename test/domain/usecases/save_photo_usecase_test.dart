

import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/domain/repositories/photo_repository.dart';
import 'package:gallery_flutter/domain/usecases/save_photo_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}

void main() {
  late MockPhotoRepository mockRepository;
  late SavePhotoUseCase useCase;

  setUp(() {
    mockRepository = MockPhotoRepository();
    useCase = SavePhotoUseCase(mockRepository);
  });

  test('should return true when photo is saved successfully', () async {
    const testUri = 'test/photo.jpg';

    when(() => mockRepository.savePhoto(testUri)).thenAnswer((_) async => true);

    final result = await useCase.execute(testUri);

    expect(result, true);
    verify(() => mockRepository.savePhoto(testUri)).called(1);
  });

  test('should return false when photo saving fails', () async {
    const testUri = 'test/photo_fail.jpg';

    when(() => mockRepository.savePhoto(testUri)).thenAnswer((_) async => false);

    final result = await useCase.execute(testUri);

    expect(result, false);
    verify(() => mockRepository.savePhoto(testUri)).called(1);
  });

}