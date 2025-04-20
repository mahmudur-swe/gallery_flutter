

import 'package:gallery_flutter/di/repository_module.dart';
import 'package:gallery_flutter/di/service_module.dart';
import 'package:gallery_flutter/di/usecase_module.dart';
import 'package:get_it/get_it.dart';

import 'bloc_module.dart';
import 'datasource_module.dart';

final locator = GetIt.instance;

Future<void> initDI() async {
  registerServices(locator);
  registerDataSource(locator);
  registerRepositories(locator);
  registerUseCases(locator);
  registerBlocs(locator);
}