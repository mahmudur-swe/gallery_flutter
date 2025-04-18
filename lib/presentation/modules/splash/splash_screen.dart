import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_event.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_state.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimens.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/util/log.dart';
import '../../../di/injection_container.dart';
import '../../routes/router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashBloc>()..add(SplashCheckPermission()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.isGranted == true) {
            context.go(AppRoutes.photos);
          } else if (state.isGranted == false) {
            Log.debug("SplashScreen. isGranted: $state, Navigate to checkPermissions");
            context.go(AppRoutes.checkPermissions);
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/images/gallery.png',
              width: AppDimens.dimen130,
              height: AppDimens.dimen130,
            ),
          ),
        ),
      ),
    );
  }
}
