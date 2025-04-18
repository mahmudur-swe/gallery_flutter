import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_event.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_state.dart';

import '../../../core/constants/app_dimens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(CheckPermission()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.isGranted == true) {
            // todo: navigate to photos screen
          } else if (state.isGranted == false) {
            // todo: navigate to no permission screen
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
