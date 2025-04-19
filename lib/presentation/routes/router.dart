import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';
import 'package:gallery_flutter/presentation/modules/permission/view/permission_screen.dart';
import 'package:gallery_flutter/presentation/modules/splash/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection_container.dart';
import '../modules/permission/bloc/permission_bloc.dart';
import '../modules/permission/bloc/permission_event.dart';
import '../modules/photos/bloc/photo_event.dart';
import '../modules/photos/cubit/download_cubit.dart';
import '../modules/photos/bloc/photo_bloc.dart';
import '../modules/photos/view/photo_screen.dart';
import '../modules/photos/cubit/selection_cubit.dart';
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
          create: (_) => sl<SplashBloc>()..add(SplashCheckPermission()),
          child: const SplashScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.checkPermissions,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => sl<PermissionBloc>()..add(CheckPermission()),
          child: const PermissionScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.photos,
      builder: (BuildContext context, GoRouterState state) {

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<PhotoBloc>()..add(LoadPhotos())),
            BlocProvider(create: (_) => SelectionCubit()),
            BlocProvider(create: (_) => DownloadCubit(sl())),
          ],
          child: PhotoScreen(thumbnailProcessor: sl()),
        );

        // return BlocProvider(
        //   // bloc injected by dependency injection
        //   create: (_) => sl<PhotoBloc>()..add(LoadPhotos()),
        //   child: PhotoScreen(
        //     thumbnailProcessor: sl<ThumbnailProcessor>(),
        //   ),
        // );
      },
    ),
  ],
);
