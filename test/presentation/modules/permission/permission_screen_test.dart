import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/core/constants/app_string.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_state.dart';
import 'package:gallery_flutter/presentation/modules/permission/view/permission_screen.dart';
import 'package:gallery_flutter/presentation/routes/router.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockPermissionBloc extends Mock implements PermissionBloc {}

void main() {
  late PermissionBloc permissionBloc;

  setUp(() {
    permissionBloc = MockPermissionBloc();
  });

  testWidgets('Displays data correctly when entered to the screen', (
    WidgetTester tester,
  ) async {
    when(() => permissionBloc.state).thenReturn(PermissionDenied());
    when(
      () => permissionBloc.stream,
    ).thenAnswer((_) => Stream.value(PermissionDenied()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PermissionBloc>.value(
          value: permissionBloc,
          child: const PermissionScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppString.requirePermission), findsNWidgets(1));
    expect(find.textContaining(AppString.msgPermission), findsOneWidget);

    expect(find.text(AppString.grantPermission), findsOneWidget);
  });

  testWidgets('Displays AlertDialog when permission is permanently denied', (
    WidgetTester tester,
  ) async {
    when(() => permissionBloc.state).thenReturn(PermissionPermanentlyDenied());
    when(
      () => permissionBloc.stream,
    ).thenAnswer((_) => Stream.value(PermissionPermanentlyDenied()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PermissionBloc>.value(
          value: permissionBloc,
          child: const PermissionScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(AppString.requirePermission), findsNWidgets(2));
    expect(find.textContaining(AppString.msgPermanentlyDenied), findsOneWidget);
  });

  testWidgets('Navigates to photos screen when permission is granted', (
    WidgetTester tester,
  ) async {
    when(() => permissionBloc.state).thenReturn(PermissionGranted());
    when(
      () => permissionBloc.stream,
    ).thenAnswer((_) => Stream.value(PermissionGranted()));

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (context, state) => BlocProvider<PermissionBloc>.value(
                    value: permissionBloc,
                    child: const PermissionScreen(),
                  ),
            ),
            GoRoute(
              path: AppRoutes.photos,
              builder:
                  (context, state) => const Scaffold(body: Text('Photos Page')),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Photos Page'), findsOneWidget);
  });
}
