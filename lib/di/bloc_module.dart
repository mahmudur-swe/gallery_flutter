import 'package:gallery_flutter/presentation/modules/permission/permission_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_bloc.dart';
import 'package:get_it/get_it.dart';

import '../presentation/modules/photos/photo_bloc.dart';

void registerBlocs(GetIt sl) {
  sl.registerFactory(() => PhotoBloc(sl()));
  sl.registerFactory(() => SplashBloc(sl()));
  sl.registerFactory(() => PermissionBloc(sl()));
}
