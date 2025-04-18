

import 'package:get_it/get_it.dart';

import '../domain/usecases/get_photos_usecase.dart';

void registerUseCases(GetIt sl) {
  sl.registerLazySingleton(() => GetPhotosUseCase(sl()));
}