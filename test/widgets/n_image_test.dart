import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skeletonizer/skeletonizer.dart';

class _MockExtendedImageState extends Mock implements ExtendedImageState {}

void main() {
  setUpAll(() {
    registerFallbackValue(LoadState.loading);
  });

  group('NImage', () {
    testWidgets('renders SizedBox when no image source is provided', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NImage(width: 100, height: 50)));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 100);
      expect(sizedBox.height, 50);
      expect(find.byType(ExtendedImage), findsNothing);
    });

    testWidgets('renders ExtendedImage with explicit imageProvider', (tester) async {
      const provider = _KeyImageProvider('explicit');

      await tester.pumpWidget(
        const MaterialApp(home: NImage(imageProvider: provider, width: 64, height: 64)),
      );
      await tester.pump();

      expect(find.byType(ExtendedImage), findsOneWidget);
      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final silent = extendedImage.image as NSilentImageProvider;
      expect(silent.delegate, provider);
    });

    testWidgets('uses network provider when url is provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NImage(url: 'https://example.com/image.png')),
      );
      await tester.pump();

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final silent = extendedImage.image as NSilentImageProvider;
      expect(silent.delegate, isA<ExtendedNetworkImageProvider>());
    });

    testWidgets('uses asset provider when asset is provided', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NImage(asset: 'assets/test.png')));
      await tester.pump();

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final silent = extendedImage.image as NSilentImageProvider;
      expect(silent.delegate, isA<ExtendedAssetImageProvider>());
    });

    testWidgets('uses memory provider when bytes are provided', (tester) async {
      final bytes = Uint8List.fromList(NSilentImageProvider.k1x1TransparentPng);

      await tester.pumpWidget(MaterialApp(home: NImage(bytes: bytes)));
      await tester.pump();

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final silent = extendedImage.image as NSilentImageProvider;
      expect(silent.delegate, isA<ExtendedMemoryImageProvider>());
    });

    testWidgets('prefers explicit imageProvider over url', (tester) async {
      const provider = _KeyImageProvider('override');

      await tester.pumpWidget(
        const MaterialApp(
          home: NImage(imageProvider: provider, url: 'https://example.com/image.png'),
        ),
      );
      await tester.pump();

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final silent = extendedImage.image as NSilentImageProvider;
      expect(silent.delegate, provider);
    });

    testWidgets('passes layout parameters to ExtendedImage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NImage(
            imageProvider: const _KeyImageProvider('layout'),
            width: 120,
            height: 80,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
            color: Colors.red,
            mode: ExtendedImageMode.gesture,
            shape: BoxShape.circle,
          ),
        ),
      );
      await tester.pump();

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      expect(extendedImage.width, 120);
      expect(extendedImage.height, 80);
      expect(extendedImage.fit, BoxFit.cover);
      expect(extendedImage.alignment, Alignment.topLeft);
      expect(extendedImage.color, Colors.red);
      expect(extendedImage.mode, ExtendedImageMode.gesture);
      expect(extendedImage.shape, BoxShape.circle);
    });

    testWidgets('uses custom loadStateChanged when provided', (tester) async {
      var customCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: NImage(
            imageProvider: const _KeyImageProvider('ok'),
            loadStateChanged: (state) {
              customCalled = true;
              return null;
            },
          ),
        ),
      );
      await tester.pump();

      expect(customCalled, isTrue);
    });

    testWidgets('shows shimmer while loading by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: NImage(imageProvider: const _KeyImageProvider('ok'))),
      );

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final loadingWidget = extendedImage.loadStateChanged!(_mockState(LoadState.loading));

      expect(loadingWidget, isA<Skeletonizer>());
    });

    testWidgets('shows onFailureFallback when load fails', (tester) async {
      const fallback = Text('fallback');

      await tester.pumpWidget(
        const MaterialApp(
          home: NImage(imageProvider: _KeyImageProvider('ok'), onFailureFallback: fallback),
        ),
      );

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final failedWidget = extendedImage.loadStateChanged!(_mockState(LoadState.failed));

      expect(failedWidget, same(fallback));
    });

    testWidgets('failed load without fallback renders empty SizedBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NImage(imageProvider: _KeyImageProvider('ok'))),
      );

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final failedWidget = extendedImage.loadStateChanged!(_mockState(LoadState.failed));

      expect(failedWidget, isA<SizedBox>());
    });

    testWidgets('completed load returns null from default loadStateChanged', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NImage(imageProvider: _KeyImageProvider('ok'))),
      );

      final extendedImage = tester.widget<ExtendedImage>(find.byType(ExtendedImage));
      final completedWidget = extendedImage.loadStateChanged!(_mockState(LoadState.completed));

      expect(completedWidget, isNull);
    });

    testWidgets('failed delegate does not report FlutterError', (tester) async {
      final reported = <FlutterErrorDetails>[];
      final previousHandler = FlutterError.onError;
      FlutterError.onError = reported.add;
      addTearDown(() => FlutterError.onError = previousHandler);

      await tester.pumpWidget(
        const MaterialApp(home: NImage(imageProvider: _FailingImageProvider())),
      );
      await tester.pump();

      expect(reported, isEmpty);
    });
  });
}

ExtendedImageState _mockState(LoadState loadState) {
  final state = _MockExtendedImageState();
  when(() => state.extendedImageLoadState).thenReturn(loadState);
  return state;
}

class _FailingImageProvider extends ImageProvider<_FailingImageProvider> {
  const _FailingImageProvider();

  @override
  Future<_FailingImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(_FailingImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: Future<ui.Codec>.error(StateError('Failed to load test image.')),
      scale: 1,
    );
  }
}

class _KeyImageProvider extends ImageProvider<_KeyImageProvider> {
  const _KeyImageProvider(this.label);

  final String label;

  @override
  Future<_KeyImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(_KeyImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_transparentImageInfo(decode));
  }

  static Future<ImageInfo> _transparentImageInfo(ImageDecoderCallback decode) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      Uint8List.fromList(NSilentImageProvider.k1x1TransparentPng),
    );
    final codec = await decode(buffer);
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image, scale: 1);
  }
}
