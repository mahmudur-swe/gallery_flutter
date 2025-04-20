import 'package:flutter/material.dart';
import 'package:gallery_flutter/core/theme/app_theme.dart';
import 'package:gallery_flutter/presentation/routes/router.dart';

import 'di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDI();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      //showPerformanceOverlay: true, // uncomment to show performance overlay
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
