import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_event.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_state.dart';

import '../../../../domain/usecases/get_photos_usecase.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetPhotosUseCase getPhotosUseCase;

  PhotoBloc(this.getPhotosUseCase) : super(PhotoState()) {
    on<LoadPhotos>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final photos = await getPhotosUseCase.execute();
        emit(
          state.copyWith(isLoading: false, errorMessage: null, photos: photos),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }

}
