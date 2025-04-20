import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/data/datasources/photo_local_data_source.dart';
import 'package:gallery_flutter/data/models/photo_response.dart';
import 'package:gallery_flutter/data/repositories/photo_repository_impl.dart';
import 'package:gallery_flutter/domain/repositories/photo_repository.dart';
import 'package:mocktail/mocktail.dart';

final testUri = 'path/to/photo.jpg';
final fakeBytes = Uint8List.fromList([0, 1, 2, 3]);

class MockPhotoLocalDataSource extends Mock implements PhotoLocalDataSource {}

void main() {
  late PhotoRepository repository;
  late MockPhotoLocalDataSource mockDataSource;

  final photoModels = [
    PhotoModel(id: '1', uri: 'https://example.com/1.jpg', name: 'Photo 1'),
    PhotoModel(id: '2', uri: 'https://example.com/2.jpg', name: 'Photo 2'),
  ];

  final domainPhotos = photoModels.map((e) => e.toDomain()).toList();

  setUp(() {
    mockDataSource = MockPhotoLocalDataSource();
    repository = PhotoRepositoryImpl(mockDataSource);

    when(
      () => mockDataSource.loadPhoto(testUri),
    ).thenAnswer((_) async => fakeBytes);
  });

  test('should return List<Photo> when datasource succeeds', () async {
    when(
      () => mockDataSource.fetchPhotos(),
    ).thenAnswer((_) async => photoModels);

    final result = await repository.getPhotos();

    expect(result, domainPhotos);
    verify(() => mockDataSource.fetchPhotos()).called(1);
  });

  test('should throw exception when datasource fails', () async {
    // Arrange
    when(
      () => mockDataSource.fetchPhotos(),
    ).thenThrow(Exception('Local error'));

    // Act & Assert
    expect(() async => await repository.getPhotos(), throwsA(isA<Exception>()));
    verify(() => mockDataSource.fetchPhotos()).called(1);
  });

  test('should return true when savePhoto succeeds', () async {
    when(
      () => mockDataSource.savePhoto(fakeBytes),
    ).thenAnswer((_) async => true);

    final result = await repository.savePhoto(testUri);

    expect(result, true);
    verify(() => mockDataSource.loadPhoto(testUri)).called(1);
    verify(() => mockDataSource.savePhoto(fakeBytes)).called(1);
  });

  test('should return false when savePhoto fails', () async {
    when(
      () => mockDataSource.savePhoto(fakeBytes),
    ).thenAnswer((_) async => false);

    final result = await repository.savePhoto(testUri);

    expect(result, false);
    verify(() => mockDataSource.loadPhoto(testUri)).called(1);
    verify(() => mockDataSource.savePhoto(fakeBytes)).called(1);
  });
}
