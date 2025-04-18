import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_screen.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/permission_service.dart';
import '../../domain/usecases/get_photos_usecase.dart';
import '../modules/photos/photo_event.dart';
import '../modules/photos/photo_screen.dart';
import '../modules/splash/splash_event.dart';



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
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.checkPermissions,
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider(
          create: (_) => PermissionBloc(PermissionService()),
          child: PermissionScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.photos,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => PhotoBloc(GetPhotosUseCase())..add(LoadPhotos()),
          child: PhotoScreen(),
        );
      },
    ),

  ],
);
