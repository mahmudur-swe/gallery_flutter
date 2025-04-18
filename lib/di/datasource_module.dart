

import 'package:gallery_flutter/data/datasources/photo_local_data_source.dart';
import 'package:get_it/get_it.dart';

void registerDataSource(GetIt sl) {
  sl.registerLazySingleton<PhotoLocalDataSource>(() => PhotoLocalDataSource());
}