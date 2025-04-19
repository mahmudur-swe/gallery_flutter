

import 'package:get_it/get_it.dart';

import '../domain/usecases/get_photos_usecase.dart';
import '../domain/usecases/save_photo_usecase.dart';

void registerUseCases(GetIt sl) {
  sl.registerLazySingleton(() => GetPhotosUseCase(sl()));
  sl.registerLazySingleton(() => SavePhotoUseCase(sl()));
}