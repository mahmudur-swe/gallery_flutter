import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/view/permission_screen.dart';
import 'package:gallery_flutter/presentation/modules/splash/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection_container.dart';
import '../modules/permission/bloc/permission_bloc.dart';
import '../modules/permission/bloc/permission_event.dart';
import '../modules/photos/bloc/photo_bloc.dart';
import '../modules/photos/bloc/photo_event.dart';
import '../modules/photos/cubit/download_cubit.dart';
import '../modules/photos/cubit/selection_cubit.dart';
import '../modules/photos/view/photo_screen.dart';
import '../modules/splash/bloc/splash_bloc.dart';
import '../modules/splash/bloc/splash_event.dart';

class AppRoutes {
  static const String photos = '/photos';
  static const String checkPermissions = '/check-permissions';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => locator<SplashBloc>()..add(SplashCheckPermission()),
          child: const SplashScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.checkPermissions,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => locator<PermissionBloc>()..add(CheckPermission()),
          child: const PermissionScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.photos,
      builder: (BuildContext context, GoRouterState state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<PhotoBloc>()..add(LoadPhotos())),
            BlocProvider(create: (_) => locator<SelectionCubit>()),
            BlocProvider(create: (_) => locator<DownloadCubit>()),
          ],
          child: PhotoScreen(thumbnailProcessor: locator()),
        );
      },
    ),
  ],
);
