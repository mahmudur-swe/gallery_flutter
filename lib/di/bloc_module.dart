// coverage:ignore-file
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_bloc.dart';
import 'package:get_it/get_it.dart';

import '../presentation/modules/photos/bloc/photo_bloc.dart';
import '../presentation/modules/photos/cubit/download_cubit.dart';
import '../presentation/modules/photos/cubit/selection_cubit.dart';


void registerBlocs(GetIt sl) {
  sl.registerFactory(() => PhotoBloc(sl()));
  sl.registerFactory(() => SplashBloc(sl()));
  sl.registerFactory(() => PermissionBloc(sl()));
  sl.registerFactory(() => SelectionCubit());
  sl.registerFactory(() => DownloadCubit(sl()));
}
