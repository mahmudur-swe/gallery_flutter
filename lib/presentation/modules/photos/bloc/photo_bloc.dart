import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_event.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_state.dart';

import '../../../../core/util/log.dart';
import '../../../../domain/usecases/get_photos_usecase.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetPhotosUseCase getPhotosUseCase;

  PhotoBloc(this.getPhotosUseCase) : super(PhotoState()) {
    on<LoadPhotos>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));


      try {
        Log.debug("PhotoBloc: Loading photos");
        // Call the photo use case to get the photos
        final photos = await getPhotosUseCase.execute();
        emit(
          state.copyWith(isLoading: false, errorMessage: null, photos: photos),
        );
        Log.debug("PhotoBloc: Photos loaded");
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
        Log.error("PhotoBloc: Error loading photos: $e");
      }
    });
  }

}
