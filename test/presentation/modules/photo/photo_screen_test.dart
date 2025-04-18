

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';
import 'package:gallery_flutter/di/injection_container.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_screen.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoBloc extends Mock implements PhotoBloc {

}

class MockThumbnailProcessor extends Mock implements ThumbnailProcessor {}

class _TestHttpOverrides extends HttpOverrides {}

final mockPhotos = [
  Photo(id: '1', uri: 'https://picsum.photos/id/10/200/300', name: 'Photo 1'),
  Photo(id: '2', uri: 'https://picsum.photos/id/11/200/301', name: 'Photo 2'),
];

void main() {
  late MockPhotoBloc mockBloc;
  late MockThumbnailProcessor mockProcessor;

  // todo: remove this when data fetching is implemented
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides(); // ✅ Prevent network image errors
  });

  setUp(() {
    mockBloc = MockPhotoBloc();
    mockProcessor = MockThumbnailProcessor();
  });



  Widget createTestableWidget() {
    return MaterialApp(
      home: BlocProvider<PhotoBloc>.value(
        value: mockBloc,
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

    when(() => mockProcessor.loadThumbnail(any(), resolution: ThumbnailResolution.low))
        .thenAnswer((_) async => Uint8List.fromList([0, 0, 0]));

    when(() => mockProcessor.loadThumbnail(any(), resolution: ThumbnailResolution.high))
        .thenAnswer((_) async => Uint8List.fromList([0, 0, 0]));


    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);

    for (final photo in mockPhotos) {
      expect(find.byKey(ValueKey(photo.uri)), findsOneWidget);
    }
  });

}

