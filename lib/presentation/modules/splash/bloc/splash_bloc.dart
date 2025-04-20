import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_event.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_state.dart';

import '../../../../core/services/permission_service.dart';
import '../../../../core/util/log.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final PermissionService permissionService;

  SplashBloc(this.permissionService) : super(const SplashState()) {
    on<SplashCheckPermission>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 1000)); // Splash delay

      Log.debug("SplashBloc: Checking permission");

      final status = await permissionService.isMediaPermissionGranted();

      Log.debug("SplashBloc: Permission status, isGranted: $status");

      emit(SplashState(isGranted: status));
    });
  }
}
