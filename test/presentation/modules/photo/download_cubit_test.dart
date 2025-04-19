

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';
import 'package:gallery_flutter/domain/usecases/save_photo_usecase.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/download_cubit.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/download_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSavePhotoUseCase extends Mock implements SavePhotoUseCase {}

final testPhotos = [
  Photo(id: '1', uri: 'uri1', name: 'Photo 1'),
  Photo(id: '2', uri: 'uri2', name: 'Photo 2'),
];

void main() {
  late DownloadCubit cubit;
  late MockSavePhotoUseCase mockUseCase;


  setUp(() {
    mockUseCase = MockSavePhotoUseCase();
    cubit = DownloadCubit(mockUseCase);
  });

  blocTest<DownloadCubit, DownloadState>(
    'emits states for successful downloads',
    build: () {
      when(() => mockUseCase.execute(any()))
          .thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.download(testPhotos),
    expect: () => [
      const DownloadState(
        isDownloading: true,
        total: 2,
        current: 0,
        downloadedIds: {},
        failedIds: {},
      ),
      DownloadState(
        isDownloading: true,
        total: 2,
        current: 1,
        downloadedIds: {'1'},
        failedIds: {},
      ),
      DownloadState(
        isDownloading: true,
        total: 2,
        current: 2,
        downloadedIds: {'1', '2'},
        failedIds: {},
      ),
      DownloadState(
        isDownloading: false,
        isComplete: true,
        total: 2,
        current: 2,
        downloadedIds: {'1', '2'},
        failedIds: {},
      ),
    ],
    verify: (_) {
      verify(() => mockUseCase.execute('uri1')).called(1);
      verify(() => mockUseCase.execute('uri2')).called(1);
    },
  );

  blocTest<DownloadCubit, DownloadState>(
    'emits states for partial failure',
    build: () {
      when(() => mockUseCase.execute('uri1')).thenAnswer((_) async => true);
      when(() => mockUseCase.execute('uri2')).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.download(testPhotos),
    expect: () => [
      const DownloadState(
        isDownloading: true,
        total: 2,
        current: 0,
        downloadedIds: {},
        failedIds: {},
      ),
      DownloadState(
        isDownloading: true,
        total: 2,
        current: 1,
        downloadedIds: {'1'},
        failedIds: {},
      ),
      DownloadState(
        isDownloading: true,
        total: 2,
        current: 2,
        downloadedIds: {'1'},
        failedIds: {'2'},
      ),
      DownloadState(
        isDownloading: false,
        isComplete: true,
        total: 2,
        current: 2,
        downloadedIds: {'1'},
        failedIds: {'2'},
      ),
    ],
  );
}