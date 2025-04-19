

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/selection_cubit.dart';

void main() {
  group('SelectionCubit', () {
    late SelectionCubit cubit;

    setUp(() {
      cubit = SelectionCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is empty set', () {
      expect(cubit.state, <String>{});
    });

    blocTest<SelectionCubit, Set<String>>(
      'emits [id] when toggle is called with new id',
      build: () => SelectionCubit(),
      act: (cubit) => cubit.toggle('id'),
      expect: () => [
        {'id'},
      ],
    );

    blocTest<SelectionCubit, Set<String>>(
      'emits [] when toggle is called twice with same id',
      build: () => SelectionCubit(),
      act: (cubit) {
        cubit.toggle('id');
        cubit.toggle('id');
      },
      expect: () => [
        {'id'},
        <String>{},
      ],
    );

    blocTest<SelectionCubit, Set<String>>(
      'emits empty set when reset is called',
      build: () => SelectionCubit(),
      seed: () => {'a', 'b'},
      act: (cubit) => cubit.reset(),
      expect: () => [
        <String>{},
      ],
    );
  });
}