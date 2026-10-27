import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Wraps any [ImageProvider] so load failures never reach [FlutterError.onError].
///
/// On failure the stream completes with a 1x1 transparent image instead of
/// reporting an error. Check loaded images with [isFailurePlaceholder] to show a
/// visible fallback. This provider only prevents framework leaks.
class NSilentImageProvider extends ImageProvider<NSilentImageProvider> {
  const new(this.delegate) : _delegateKey = null;

  const new _(this.delegate, this._delegateKey);

  final ImageProvider<Object> delegate;
  final Object? _delegateKey;

  static const Duration failureCacheTtl = .new(seconds: 60);

  static final Map<int, DateTime> _failedAtByKeyId = <int, DateTime>{};
  static const int _maxFailedKeys = 2048;

  static ui.Image? _failurePlaceholderImage;

  /// Whether [info] is the transparent image this provider completes with on failure.
  static bool isFailurePlaceholder(ImageInfo? info) {
    final placeholder = _failurePlaceholderImage;
    return info != null && placeholder != null && info.image.isCloneOf(placeholder);
  }

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
  Future<NSilentImageProvider> obtainKey(ImageConfiguration configuration) {
    final future = delegate.obtainKey(configuration);
    if (future is SynchronousFuture) {
      late NSilentImageProvider key;
      future.then((delegateKey) {
        key = NSilentImageProvider._(delegate, delegateKey);
      });
      return SynchronousFuture(key);
    }
    return future.then((delegateKey) => NSilentImageProvider._(delegate, delegateKey));
  }

  @override
  ImageStreamCompleter loadImage(NSilentImageProvider key, ImageDecoderCallback decode) {
    final delegateKey = key._delegateKey;
    if (delegateKey == null || isKnownFailed(delegateKey)) {
      return _oneFrameUntilComplete(
        _failurePlaceholderInfo(decode),
        informationCollector: key._informationCollector,
      );
    }
    return _SilentImageStreamCompleter(
      key.delegate.loadImage(delegateKey, decode),
      delegateKey,
      decode,
    );
  }

  static ImageStreamCompleter _oneFrameUntilComplete(
    Future<ImageInfo> image, {
    InformationCollector? informationCollector,
  }) {
    final completer = OneFrameImageStreamCompleter(
      image,
      informationCollector: informationCollector,
    );
    final handle = completer.keepAlive();
    image.whenComplete(handle.dispose);
    return completer;
  }

  List<DiagnosticsNode> _informationCollector() {
    return <DiagnosticsNode>[
      DiagnosticsProperty<ImageProvider<Object>>('Wrapped provider', delegate),
    ];
  }

  static Future<ImageInfo> _failurePlaceholderInfo(ImageDecoderCallback decode) async {
    final placeholder = _failurePlaceholderImage ?? await _decodeTransparentImage(decode);
    return ImageInfo(image: placeholder.clone(), scale: 1);
  }

  static Future<ui.Image> _decodeTransparentImage(ImageDecoderCallback decode) async {
    final codec = await _transparentCodec(decode);
    final frame = await codec.getNextFrame();
    return _failurePlaceholderImage ??= frame.image;
  }

  static Future<ui.Codec> _transparentCodec(ImageDecoderCallback decode) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(.fromList(k1x1TransparentPng));
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

class _SilentImageStreamCompleter(
  final ImageStreamCompleter _delegate,
  final Object _delegateKey,
  final ImageDecoderCallback _decode,
) extends ImageStreamCompleter {
  this {
    _delegateHandle = _delegate.keepAlive();
    _pendingHandle = keepAlive();
    _delegate.addListener(_relay);
  }

  late final ImageStreamCompleterHandle _delegateHandle;
  ImageStreamCompleterHandle? _pendingHandle;
  late final _relay = ImageStreamListener(_onFrame, onError: _onError);
  var _relaying = true;

  void _onFrame(ImageInfo info, bool _) {
    setImage(info);
    if (_pendingHandle != null) {
      NSilentImageProvider.markLoadSucceeded(_delegateKey);
      _settle();
    }
  }

  Future<void> _onError(Object _, StackTrace? _) async {
    if (_pendingHandle == null) {
      return;
    }
    NSilentImageProvider.markLoadFailed(_delegateKey);
    setImage(await NSilentImageProvider._failurePlaceholderInfo(_decode));
    _settle();
  }

  void _settle() {
    final pending = _pendingHandle!;
    _pendingHandle = null;
    if (!hasListeners) {
      _detach();
    }
    pending.dispose();
  }

  void _detach() {
    if (_relaying) {
      _relaying = false;
      _delegate.removeListener(_relay);
    }
  }

  @override
  void addListener(ImageStreamListener listener) {
    if (!_relaying) {
      _relaying = true;
      _delegate.addListener(_relay);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(ImageStreamListener listener) {
    super.removeListener(listener);
    if (!hasListeners && _pendingHandle == null) {
      _detach();
    }
  }

  @override
  void onDisposed() {
    _detach();
    _delegateHandle.dispose();
    super.onDisposed();
  }
}
