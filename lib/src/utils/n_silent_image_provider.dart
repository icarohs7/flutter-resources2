import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Wraps any [ImageProvider] so load failures never reach [FlutterError.onError].
///
/// On failure the stream completes with a 1x1 transparent image instead of
/// reporting an error. Use [isKnownFailed] / [didFail] with [onFailureFallback]
/// to show a visible placeholder. This provider only prevents framework leaks.
///
/// Animated images are reduced to a single frame when loaded through this wrapper.
class NSilentImageProvider extends ImageProvider<NSilentImageProvider> {
  const NSilentImageProvider(this.delegate) : _delegateKey = null;

  const NSilentImageProvider._(this.delegate, this._delegateKey);

  final ImageProvider<Object> delegate;
  final Object? _delegateKey;

  static const Duration failureCacheTtl = Duration(seconds: 60);

  static final Map<int, DateTime> _failedAtByKeyId = <int, DateTime>{};
  static const int _maxFailedKeys = 2048;

  static ImageProvider<Object>? wrap(ImageProvider<Object>? provider) {
    if (provider == null) {
      return null;
    }
    if (provider is NSilentImageProvider) {
      return provider;
    }
    return NSilentImageProvider(provider);
  }

  bool get didFail => _delegateKey != null && isKnownFailed(_delegateKey);

  static bool isKnownFailed(Object delegateKey) {
    _pruneExpiredFailures();
    final keyId = _keyId(delegateKey);
    final failedAt = _failedAtByKeyId[keyId];
    if (failedAt == null) {
      return false;
    }
    if (DateTime.now().difference(failedAt) >= failureCacheTtl) {
      _failedAtByKeyId.remove(keyId);
      return false;
    }
    return true;
  }

  static void markLoadFailed(Object delegateKey) {
    _pruneExpiredFailures();
    while (_failedAtByKeyId.length >= _maxFailedKeys) {
      _evictOldestFailure();
    }
    _failedAtByKeyId[_keyId(delegateKey)] = DateTime.now();
  }

  static void markLoadSucceeded(Object delegateKey) {
    _failedAtByKeyId.remove(_keyId(delegateKey));
  }

  static void _pruneExpiredFailures() {
    final now = DateTime.now();
    _failedAtByKeyId.removeWhere((_, failedAt) => now.difference(failedAt) >= failureCacheTtl);
  }

  static void _evictOldestFailure() {
    if (_failedAtByKeyId.isEmpty) {
      return;
    }
    var oldestKeyId = _failedAtByKeyId.keys.first;
    var oldestAt = _failedAtByKeyId[oldestKeyId]!;
    for (final entry in _failedAtByKeyId.entries) {
      if (entry.value.isBefore(oldestAt)) {
        oldestKeyId = entry.key;
        oldestAt = entry.value;
      }
    }
    _failedAtByKeyId.remove(oldestKeyId);
  }

  static int _keyId(Object delegateKey) => identityHashCode(delegateKey);

  @override
  Future<NSilentImageProvider> obtainKey(ImageConfiguration configuration) async {
    final delegateKey = await delegate.obtainKey(configuration);
    return NSilentImageProvider._(delegate, delegateKey);
  }

  @override
  ImageStreamCompleter loadImage(NSilentImageProvider key, ImageDecoderCallback decode) {
    final delegateKey = key._delegateKey;
    if (delegateKey == null) {
      return OneFrameImageStreamCompleter(
        _transparentImageInfo(decode),
        informationCollector: key._informationCollector,
      );
    }

    if (isKnownFailed(delegateKey)) {
      return OneFrameImageStreamCompleter(
        _transparentImageInfo(decode),
        informationCollector: key._informationCollector,
      );
    }

    return OneFrameImageStreamCompleter(
      _loadSilently(key.delegate, delegateKey, decode),
      informationCollector: key._informationCollector,
    );
  }

  List<DiagnosticsNode> _informationCollector() {
    return <DiagnosticsNode>[
      DiagnosticsProperty<ImageProvider<Object>>('Wrapped provider', delegate),
    ];
  }

  static Future<ImageInfo> _loadSilently(
    ImageProvider<Object> provider,
    Object delegateKey,
    ImageDecoderCallback decode,
  ) async {
    try {
      final imageInfo = await _loadImageInfo(provider, delegateKey, decode);
      markLoadSucceeded(delegateKey);
      return imageInfo;
    } catch (_) {
      markLoadFailed(delegateKey);
      return _transparentImageInfo(decode);
    }
  }

  static Future<ImageInfo> _loadImageInfo(
    ImageProvider<Object> provider,
    Object delegateKey,
    ImageDecoderCallback decode,
  ) {
    final streamCompleter = provider.loadImage(delegateKey, decode);
    final result = Completer<ImageInfo>();
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (!result.isCompleted) {
          result.complete(info);
        }
      },
      onError: (Object error, StackTrace? stackTrace) {
        if (!result.isCompleted) {
          result.completeError(error, stackTrace);
        }
      },
    );

    streamCompleter.addListener(listener);
    return result.future.whenComplete(() => streamCompleter.removeListener(listener));
  }

  static Future<ImageInfo> _transparentImageInfo(ImageDecoderCallback decode) async {
    final codec = await _transparentCodec(decode);
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image, scale: 1);
  }

  static Future<ui.Codec> _transparentCodec(ImageDecoderCallback decode) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(Uint8List.fromList(k1x1TransparentPng));
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NSilentImageProvider &&
        other.delegate == delegate &&
        other._delegateKey == _delegateKey;
  }

  @override
  int get hashCode => Object.hash(delegate, _delegateKey);

  static const List<int> k1x1TransparentPng = <int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ];
}
