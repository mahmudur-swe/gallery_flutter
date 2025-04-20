import 'package:gallery_flutter/data/datasources/photo_local_data_source.dart';
import 'package:get_it/get_it.dart';

import '../core/services/thumbnail_processor.dart';
import '../data/datasources/native_photo_local_data_source.dart';

void registerDataSource(GetIt sl) {
  sl.registerLazySingleton<PhotoLocalDataSource>(
    () => NativePhotoLocalDataSource(sl()),
  );
  sl.registerLazySingleton<ThumbnailProcessor>(
    () => ThumbnailProcessorImpl(sl())..init(),
  );
}
