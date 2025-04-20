// coverage:ignore-file
import 'package:get_it/get_it.dart';

import '../data/repositories/photo_repository_impl.dart';
import '../domain/repositories/photo_repository.dart';

void registerRepositories(GetIt sl) {
  sl.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(sl()));
}
