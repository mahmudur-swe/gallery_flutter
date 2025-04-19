

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';
import 'package:gallery_flutter/di/injection_container.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_state.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/download_cubit.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/download_state.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/view/photo_screen.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/selection_cubit.dart';
import 'package:mocktail/mocktail.dart';


final validImageBytes = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG header
  0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, // IHDR chunk
  0x00, 0x00, 0x00, 0x01, // width: 1
  0x00, 0x00, 0x00, 0x01, // height: 1
  0x08, 0x06, 0x00, 0x00, 0x00,
  0x1F, 0x15, 0xC4, 0x89,
  0x00, 0x00, 0x00, 0x0A,
  0x49, 0x44, 0x41, 0x54, // IDAT chunk
  0x78, 0x9C, 0x63, 0x00,
  0x01, 0x00, 0x00, 0x05, 0x00, 0x01,
  0x0D, 0x0A, 0x2D, 0xB4,
  0x00, 0x00, 0x00, 0x00,
  0x49, 0x45, 0x4E, 0x44,
  0xAE, 0x42, 0x60, 0x82
]);

class MockPhotoBloc extends Mock implements PhotoBloc {

}

class MockThumbnailProcessor extends Mock implements ThumbnailProcessor {}

class MockSelectionCubit extends Mock implements SelectionCubit {}

class MockDownloadCubit extends Mock implements DownloadCubit {}


class _TestHttpOverrides extends HttpOverrides {}



final mockPhotos = [
  Photo(id: '1', uri: 'https://picsum.photos/id/10/200/300', name: 'Photo 1'),
  Photo(id: '2', uri: 'https://picsum.photos/id/11/200/301', name: 'Photo 2'),
];

void main() {
  late MockPhotoBloc mockBloc;
  late MockSelectionCubit mockSelectionCubit;
  late MockDownloadCubit mockDownloadCubit;
  late MockThumbnailProcessor mockProcessor;

  // todo: remove this when data fetching is implemented
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides(); // ✅ Prevent network image errors
  });

  setUp(() {
    mockBloc = MockPhotoBloc();
    mockProcessor = MockThumbnailProcessor();
    mockSelectionCubit = MockSelectionCubit();
    mockDownloadCubit = MockDownloadCubit();
  });



  Widget createTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PhotoBloc>.value(value: mockBloc),
          BlocProvider<SelectionCubit>.value(value: mockSelectionCubit),
          BlocProvider<DownloadCubit>.value(value: mockDownloadCubit),
        ],
        child:  PhotoScreen(thumbnailProcessor: mockProcessor),
      ),
    );
  }

  testWidgets('shows loading indicator when isLoading is true', (tester) async {

    when(() => mockBloc.state).thenReturn(PhotoState(isLoading: true));
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(PhotoState(isLoading: true)));


    await tester.pumpWidget(createTestableWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when errorMessage is present', (tester) async {
    when(() => mockBloc.state).thenReturn(PhotoState(errorMessage: 'Something went wrong'));
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(PhotoState(errorMessage: 'Something went wrong')));

    await tester.pumpWidget(createTestableWidget());
    expect(find.text('Error: Something went wrong'), findsOneWidget);
  });

  testWidgets('renders photo thumbnails when photos are present', (tester) async {
    when(() => mockBloc.state).thenReturn(PhotoState(photos: mockPhotos));
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(PhotoState(photos: mockPhotos)));

    when(() => mockSelectionCubit.stream).thenAnswer((_) => Stream.value(<String>{}));
    when(() => mockSelectionCubit.state).thenReturn(<String>{});

    when(() => mockDownloadCubit.stream).thenAnswer((_) => Stream.value(const DownloadState()));
    when(() => mockDownloadCubit.state).thenReturn(const DownloadState());


    when(() => mockProcessor.loadThumbnail(any(), resolution: ThumbnailResolution.low))
        .thenAnswer((_) async => validImageBytes);

    when(() => mockProcessor.loadThumbnail(any(), resolution: ThumbnailResolution.high))
        .thenAnswer((_) async => validImageBytes);


    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);

    for (final photo in mockPhotos) {
      expect(find.byKey(ValueKey(photo.uri)), findsOneWidget);
    }
  });

}

