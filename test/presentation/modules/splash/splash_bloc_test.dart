

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/core/services/permission_service.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_bloc.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_event.dart';
import 'package:gallery_flutter/presentation/modules/splash/bloc/splash_state.dart';
import 'package:mocktail/mocktail.dart';

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late SplashBloc splashBloc;
  late MockPermissionService mockPermissionService;

  setUp(() {
    mockPermissionService = MockPermissionService();
    splashBloc = SplashBloc(mockPermissionService);
  });

  tearDown(() => splashBloc.close());

  test('initial state is SplashState()', () {
    expect(splashBloc.state, const SplashState());
  });

  test('should call PermissionService once when SplashCheckPermission is added', () async {
    // Arrange
    when(() => mockPermissionService.isMediaPermissionGranted())
        .thenAnswer((_) async => true);

    final bloc = SplashBloc(mockPermissionService);

    // Act
    bloc.add(SplashCheckPermission());

    // Wait for the async method to be called
    await untilCalled(() => mockPermissionService.isMediaPermissionGranted());

    // Assert
    verify(() => mockPermissionService.isMediaPermissionGranted()).called(1);
  });


  blocTest<SplashBloc, SplashState>(
    'emits SplashState(true) when permission is granted',
    build: () {
      when(() => mockPermissionService.isMediaPermissionGranted())
          .thenAnswer((_) async => true);
      return SplashBloc(mockPermissionService);
    },
    act: (bloc) => bloc.add(SplashCheckPermission()),
    wait: const Duration(milliseconds: 1100),
    expect: () => [const SplashState(isGranted: true)],
  );

  blocTest<SplashBloc, SplashState>(
    'emits SplashState(false) when permission is denied',
    build: () {
      when(() => mockPermissionService.isMediaPermissionGranted())
          .thenAnswer((_) async => false);
      return SplashBloc(mockPermissionService);
    },
    act: (bloc) => bloc.add(SplashCheckPermission()),
    wait: const Duration(milliseconds: 1100),
    expect: () => [const SplashState(isGranted: false)],
  );
}