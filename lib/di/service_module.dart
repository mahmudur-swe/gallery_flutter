

import 'package:gallery_flutter/core/services/permission_service.dart';
import 'package:get_it/get_it.dart';

void registerServices(GetIt sl) {
  sl.registerLazySingleton<PermissionService>(() => PermissionService());
}