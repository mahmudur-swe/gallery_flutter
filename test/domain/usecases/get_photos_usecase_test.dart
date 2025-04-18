

import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';
import 'package:gallery_flutter/domain/repositories/photo_repository.dart';
import 'package:gallery_flutter/domain/usecases/get_photos_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}

final mockPhotos = [
   Photo(
    id: '1',
    uri: 'https://example.com/photo1.jpg',
    name: 'Test Photo 1',
    size: 12345,
    timestamp: 0
  ),
   Photo(
    id: '2',
    uri: 'https://example.com/photo2.jpg',
    name: 'Test Photo 2',
    size: 67890,
    timestamp: 0
  ),
];

void main() {
  late GetPhotosUseCase useCase;
  late MockPhotoRepository mockRepository;


  setUp(() {
    mockRepository = MockPhotoRepository();
    useCase = GetPhotosUseCase(mockRepository);
  });

  test('should return list of photos from repository', () async {
    when(() => mockRepository.getPhotos()).thenAnswer((_) async => mockPhotos);

    final result = await useCase.execute();

    expect(result, mockPhotos);
    verify(() => mockRepository.getPhotos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when repository fails', () async {
    // Arrange
    when(() => mockRepository.getPhotos()).thenThrow(Exception('repo failed'));

    // Act & Assert
    expect(
          () async => await useCase.execute(),
      throwsA(isA<Exception>()),
    );

    verify(() => mockRepository.getPhotos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}