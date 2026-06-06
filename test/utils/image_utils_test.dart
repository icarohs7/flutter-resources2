import 'package:flutter/foundation.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageUtils.getImageProviderFor', () {
    test('returns ExtendedNetworkImageProvider for imageUrl', () {
      final provider = ImageUtils.getImageProviderFor(imageUrl: 'https://example.com/a.png');

      expect(provider, isA<ExtendedNetworkImageProvider>());
    });

    test('returns ExtendedAssetImageProvider for assetPath', () {
      final provider = ImageUtils.getImageProviderFor(assetPath: 'assets/test.png');

      expect(provider, isA<ExtendedAssetImageProvider>());
    });

    test('returns ExtendedMemoryImageProvider for bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final provider = ImageUtils.getImageProviderFor(bytes: bytes);

      expect(provider, isA<ExtendedMemoryImageProvider>());
      expect((provider as ExtendedMemoryImageProvider).bytes, bytes);
    });

    test('returns ExtendedFileImageProvider for filePath on non-web', () {
      if (kIsWeb) return;

      final provider = ImageUtils.getImageProviderFor(filePath: '/tmp/test.png');

      expect(provider, isA<ExtendedFileImageProvider>());
    });

    test('returns empty memory provider for filePath on web', () {
      if (!kIsWeb) return;

      final provider = ImageUtils.getImageProviderFor(filePath: '/tmp/test.png');

      expect(provider, isA<ExtendedMemoryImageProvider>());
      expect((provider as ExtendedMemoryImageProvider).bytes, isEmpty);
    });

    test('throws when all parameters are null', () {
      expect(() => ImageUtils.getImageProviderFor(), throwsArgumentError);
    });
  });

  group('ImageUtils.encode', () {
    late img.Image image;

    setUp(() {
      image = img.Image(width: 2, height: 2);
      img.fill(image, color: img.ColorRgb8(10, 20, 30));
    });

    test('returns null when no image source is provided', () async {
      expect(await ImageUtils.encode(), isNull);
    });

    test('encodes an image instance as png by default', () async {
      final bytes = await ImageUtils.encode(image: image);

      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(0));
      expect(img.decodeImage(bytes), isNotNull);
    });

    test('encodes an image instance as jpeg when requested', () async {
      final bytes = await ImageUtils.encode(image: image, contentType: 'image/jpeg');

      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(0));
      expect(img.decodeImage(bytes), isNotNull);
    });

    test('encodes image bytes as gif when requested', () async {
      final pngBytes = await ImageUtils.encode(image: image);
      final bytes = await ImageUtils.encode(imageBytes: pngBytes, contentType: 'image/gif');

      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(0));
    });
  });

  group('ImageUtils.resize', () {
    test('returns null when neither imageBytes nor filePath is provided', () async {
      expect(await ImageUtils.resize(), isNull);
    });
  });
}
