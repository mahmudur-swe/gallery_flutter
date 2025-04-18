

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';
import 'package:gallery_flutter/domain/usecases/get_photos_usecase.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_event.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPhotosUseCase extends Mock implements GetPhotosUseCase {}

final testPhotos = [
  Photo(
    id: '1',
    uri: 'https://picsum.photos/id/10/200/300',
    name: 'Photo 1'
  ),
  Photo(
    id: '2',
    uri: 'https://picsum.photos/id/11/200/301',
    name: 'Photo 2'
  ),
];

void main() {
  late MockGetPhotosUseCase mockGetPhotosUseCase;
  late PhotoBloc bloc;

  setUp(() {
    mockGetPhotosUseCase = MockGetPhotosUseCase();
    bloc = PhotoBloc(mockGetPhotosUseCase);
  });

  tearDown(() => bloc.close());

  blocTest<PhotoBloc, PhotoState>(
    'emits [loading, success] when usecase returns photos',
    build: () {
      when(() => mockGetPhotosUseCase.execute())
          .thenAnswer((_) async => testPhotos);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPhotos()),
    wait: const Duration(seconds: 3), // Simulated delay
    expect: () => [
      PhotoState(isLoading: true),
      PhotoState(isLoading: false, photos: testPhotos),
    ],
    verify: (_) {
      verify(() => mockGetPhotosUseCase.execute()).called(1);
    },
  );

  blocTest<PhotoBloc, PhotoState>(
    'emits [loading, error] when usecase throws an exception',
    build: () {
      when(() => mockGetPhotosUseCase.execute())
          .thenThrow(Exception('load failed'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPhotos()),
    wait: const Duration(seconds: 3),
    expect: () => [
      PhotoState(isLoading: true),
      PhotoState(isLoading: false, errorMessage: 'Exception: load failed'),
    ],
    verify: (_) {
      verify(() => mockGetPhotosUseCase.execute()).called(1);
    },
  );
}