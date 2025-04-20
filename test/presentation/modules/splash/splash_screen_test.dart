import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_state.dart';
import 'package:gallery_flutter/presentation/modules/splash/view/splash_screen.dart';
import 'package:gallery_flutter/presentation/routes/router.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSplashBloc extends Mock implements SplashBloc {}

void main() {
  late SplashBloc splashBloc;

  setUp(() {
    splashBloc = MockSplashBloc();
  });

  testWidgets('Navigates to photos when permission is granted', (tester) async {
    when(() => splashBloc.state).thenReturn(const SplashState(isGranted: true));
    when(
      () => splashBloc.stream,
    ).thenAnswer((_) => Stream.value(const SplashState(isGranted: true)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<SplashBloc>.value(
                    value: splashBloc,
                    child: const SplashScreen(),
                  ),
            ),
            GoRoute(
              path: AppRoutes.photos,
              builder: (_, __) => const Scaffold(body: Text('Photos Page')),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Photos Page'), findsOneWidget);
  });

  testWidgets('Navigates to permissions when permission is denied', (
    tester,
  ) async {
    when(
      () => splashBloc.state,
    ).thenReturn(const SplashState(isGranted: false));
    when(
      () => splashBloc.stream,
    ).thenAnswer((_) => Stream.value(const SplashState(isGranted: false)));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<SplashBloc>.value(
                    value: splashBloc,
                    child: const SplashScreen(),
                  ),
            ),
            GoRoute(
              path: AppRoutes.checkPermissions,
              builder:
                  (_, __) => const Scaffold(body: Text('Permissions Page')),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Permissions Page'), findsOneWidget);
  });
}
