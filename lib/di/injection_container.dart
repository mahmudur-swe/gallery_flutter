

import 'package:gallery_flutter/di/repository_module.dart';
import 'package:gallery_flutter/di/service_module.dart';
import 'package:gallery_flutter/di/usecase_module.dart';
import 'package:get_it/get_it.dart';

import 'bloc_module.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  registerServices(sl);
  registerRepositories(sl);
  registerUseCases(sl);
  registerBlocs(sl);
}