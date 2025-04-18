import 'package:flutter/material.dart';
import 'package:gallery_flutter/core/theme/app_theme.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_screen.dart';
import 'package:gallery_flutter/presentation/modules/splash/splash_screen.dart';
import 'package:gallery_flutter/presentation/routes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gallery Flutter',
      theme: appTheme,
      routerConfig: appRouter
    );
  }
}
