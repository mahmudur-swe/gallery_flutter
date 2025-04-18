


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_event.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_state.dart';

import '../../../core/services/permission_service.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<CheckPermission>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 1000)); // Splash delay
      final status = await PermissionService().isMediaPermissionGranted();
      emit(SplashState(isGranted: status));
    });
  }
}