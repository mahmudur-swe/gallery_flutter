import 'package:flutter/cupertino.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_screen.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../modules/photos/photo_screen.dart';

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
        return PermissionScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.photos,
      builder: (BuildContext context, GoRouterState state) {
        return PhotoScreen();
      },
    ),
  ],
);
