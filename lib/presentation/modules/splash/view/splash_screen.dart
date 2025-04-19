import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/core/constants/app_assets.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/util/log.dart';
import '../../../routes/router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.isGranted == true) {
          context.go(AppRoutes.photos);
        } else if (state.isGranted == false) {
          Log.debug(
            "SplashScreen. isGranted: $state, Navigate to checkPermissions",
          );
          context.go(AppRoutes.checkPermissions);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            AppAssets.gallery,
            width: AppDimens.dimen130,
            height: AppDimens.dimen130,
          ),
        ),
      ),
    );
  }
}
