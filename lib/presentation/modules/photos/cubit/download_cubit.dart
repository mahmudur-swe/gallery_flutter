import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/domain/usecases/save_photo_usecase.dart';

import '../../../../core/util/log.dart';
import '../../../../domain/entities/photo.dart';
import 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final SavePhotoUseCase savePhotoUseCase;

  DownloadCubit(this.savePhotoUseCase) : super(const DownloadState());

  Future<void> download(List<Photo> photos) async {
    final downloaded = <String>{};
    final failed = <String>{};

    Log.debug("DownloadCubit: Download started");
    // set the state to downloading
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

      // Download the photo
      Log.debug("DownloadCubit: Downloading photo [ID: $photo.id]");
      final success = await savePhotoUseCase.execute(photo.uri);

      if (success) {
        Log.debug("DownloadCubit: Photo [ID: $photo.id] saved successfully");
        downloaded.add(photo.id);
      } else {
        Log.debug("DownloadCubit: Photo [ID: $photo.id] failed to save");
        failed.add(photo.id);
      }

      // Update the state only if the download is still in progress
      if (state.isDownloading) {
        emit(
          state.copyWith(
            current: state.current + 1,
            downloadedIds: state.downloadedIds.union(downloaded),
            failedIds: state.failedIds.union(failed),
          ),
        );
      }
    }

    // If the download is still in progress, update the state
    if (state.isDownloading) {
      Log.debug("DownloadCubit: Download complete");
      emit(state.copyWith(isDownloading: false, isComplete: true));
    }
  }

  void reset() => {
    emit(const DownloadState()),
    Log.debug("DownloadCubit: Reset"),
  };
}
