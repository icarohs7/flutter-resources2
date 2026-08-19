import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_resources2/src/utils/n_silent_image_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NSilentImageProvider.wrap', () {
    test('returns null for null input', () {
      expect(NSilentImageProvider.wrap(null), isNull);
    });

    test('does not double-wrap', () {
      const inner = _KeyImageProvider('asset');
      final wrapped = NSilentImageProvider.wrap(inner);

      expect(wrapped, isA<NSilentImageProvider>());
      expect(NSilentImageProvider.wrap(wrapped), same(wrapped));
    });
  });

  group('NSilentImageProvider', () {
    testWidgets('failed delegate does not report FlutterError', (tester) async {
      final reported = <FlutterErrorDetails>[];
      final previousHandler = FlutterError.onError;
      FlutterError.onError = reported.add;
      addTearDown(() => FlutterError.onError = previousHandler);

      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: Image(image: NSilentImageProvider(_FailingImageProvider()))),
        ),
      );
      await tester.pumpAndSettle();

      expect(reported, isEmpty);
    });

    testWidgets('successful delegate still resolves an image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: Image(image: NSilentImageProvider(_KeyImageProvider('ok')))),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    test('completing after the last listener is removed does not throw', () async {
      final pending = Completer<ImageInfo>();
      final provider = NSilentImageProvider(_DelayedImageProvider(pending));
      final key = await provider.obtainKey(ImageConfiguration.empty);
      final completer = provider.loadImage(key, _decode);

      final listener = ImageStreamListener((_, _) {});
      completer.addListener(listener);
      completer.removeListener(listener);

      pending.complete(await _imageInfoFromPng());
      await Future<void>.delayed(Duration.zero);
    });
  });
}

Future<ui.Codec> _decode(
  ui.ImmutableBuffer buffer, {
  ui.TargetImageSize Function(int, int)? getTargetSize,
}) {
  return ui.instantiateImageCodecFromBuffer(buffer);
}

Future<ImageInfo> _imageInfoFromPng() async {
  final codec = await ui.instantiateImageCodec(
    Uint8List.fromList(NSilentImageProvider.k1x1TransparentPng),
  );
  final frame = await codec.getNextFrame();
  return ImageInfo(image: frame.image, scale: 1);
}

class _DelayedImageProvider extends ImageProvider<_DelayedImageProvider> {
  const _DelayedImageProvider(this.pending);

  final Completer<ImageInfo> pending;

  @override
  Future<_DelayedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(_DelayedImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(pending.future);
  }
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
