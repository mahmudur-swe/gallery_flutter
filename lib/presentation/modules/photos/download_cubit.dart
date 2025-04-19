import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/domain/usecases/save_photo_usecase.dart';

import '../../../domain/entities/photo.dart';
import 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final SavePhotoUseCase savePhotoUseCase;

  DownloadCubit(this.savePhotoUseCase) : super(const DownloadState());

  Future<void> download(List<Photo> photos) async {
    final downloaded = <String>{};
    final failed = <String>{};

    emit(
      state.copyWith(
        isDownloading: true,
        total: photos.length,
        current: 0,
        downloadedIds: {},
        failedIds: {},
      ),
    );

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];

      final success = await savePhotoUseCase.execute(photo.name, photo.uri);
      if (success) {
        downloaded.add(photo.id);
      } else {
        failed.add(photo.id);
      }

      if(state.isDownloading){
        emit(
          state.copyWith(
            current: i + 1,
            downloadedIds: downloaded,
            failedIds: failed,
          ),
        );
      }

    }

    if(state.isDownloading) {
      emit(state.copyWith(isDownloading: false, isComplete: true));
    }

  }

  void reset() => emit(const DownloadState());
}
