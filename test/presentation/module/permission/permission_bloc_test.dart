

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/core/services/permission_service.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_event.dart';
import 'package:gallery_flutter/presentation/modules/permission/permission_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late PermissionBloc bloc;
  late MockPermissionService mockPermissionService;

  setUp(() {
    mockPermissionService = MockPermissionService();
    bloc = PermissionBloc(mockPermissionService);
  });

  tearDown(() => bloc.close());

  group('CheckPermission', () {
    blocTest<PermissionBloc, PermissionState>(
      'emits [PermissionGranted] when permission is granted',
      build: () {
        when(() => mockPermissionService.isMediaPermissionGranted())
            .thenAnswer((_) async => true);
        return PermissionBloc(mockPermissionService);
      },
      act: (bloc) => bloc.add(CheckPermission()),
      expect: () => [PermissionGranted()],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [PermissionDenied] when permission is denied',
      build: () {
        when(() => mockPermissionService.isMediaPermissionGranted())
            .thenAnswer((_) async => false);
        return PermissionBloc(mockPermissionService);
      },
      act: (bloc) => bloc.add(CheckPermission()),
      expect: () => [PermissionDenied()],
    );
  });

  group('RequestPermission', () {
    blocTest<PermissionBloc, PermissionState>(
      'emits [PermissionGranted] when permission is granted',
      build: () {
        when(() => mockPermissionService.requestMediaPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        return PermissionBloc(mockPermissionService);
      },
      act: (bloc) => bloc.add(RequestPermission()),
      expect: () => [PermissionGranted()],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [PermissionDenied] when permission is denied',
      build: () {
        when(() => mockPermissionService.requestMediaPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        return PermissionBloc(mockPermissionService);
      },
      act: (bloc) => bloc.add(RequestPermission()),
      expect: () => [PermissionDenied()],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [PermissionPermanentlyDenied] when permission is permanently denied',
      build: () {
        when(() => mockPermissionService.requestMediaPermission())
            .thenAnswer((_) async => PermissionStatus.permanentlyDenied);
        return PermissionBloc(mockPermissionService);
      },
      act: (bloc) => bloc.add(RequestPermission()),
      expect: () => [PermissionPermanentlyDenied()],
    );
  });
}