import 'dart:async';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

import 'mobile_only_utils.dart' as utils_mobile;

abstract class ImageUtils {
  /// Resize the given image from its byte data or file path
  /// to the given [imageWidth], retaining its
  /// original proportions
  ///
  /// The operation will happen in a background isolate on
  /// platforms that support it, or run synchronously otherwise
  static Future<Uint8List?> resize({
    Uint8List? imageBytes,
    String? filePath,
    int imageWidth = 800,
  }) async {
    if (imageBytes != null) {
      return await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 800,
        minWidth: 800,
        quality: 85,
      );
    }

    if (filePath != null) {
      return await FlutterImageCompress.compressWithFile(
        filePath,
        minHeight: 800,
        minWidth: 800,
        quality: 85,
      );
    }

    return null;
  }

  /// Encode the given image to its byte data, from either
  /// the [image] instance or the bytes of the image
  /// through [imageBytes]
  ///
  /// [contentType] must be a string represent the
  /// mime type of the image e.g. image/jpeg, image/jpg, etc.
  ///
  /// The operation will happen in a background isolate on
  /// platforms that support it, or run synchronously otherwise
  static Future<Uint8List?> encode({
    Uint8List? imageBytes,
    img.Image? image,
    String? filePath,
    String contentType = 'image/jpg',
  }) async {
    final cmd = _createCommand(imageBytes, image, filePath);
    if (cmd == null) return null;

    switch (contentType) {
      case 'image/jpeg':
      case 'image/jpg':
        cmd.encodeJpg();
      case 'image/gif':
        cmd.encodeGif();
      case 'image/x-icon':
        cmd.encodeIco();
      case 'image/bmp':
        cmd.encodeBmp();
      case 'image/x-targa':
      case 'image/x-tga':
        cmd.encodeTga();
      case 'image/tiff':
      case 'image/tiff-fx':
        cmd.encodeTiff();
      default:
        cmd.encodePng();
    }

    return await img.executeCommandBytesAsync(cmd);
  }

  /// Load an image from the given [url], returning
  /// its byte data
  static Future<Uint8List?> loadNetworkImage(String url) async {
    final completer = Completer<ImageInfo>();
    final img = NetworkImage(url);
    img
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// Returns the correct image provider according to the
  /// type of data used
  static ImageProvider getImageProviderFor({
    String? imageUrl,
    String? assetPath,
    String? filePath,
    Uint8List? bytes,
  }) {
    if (imageUrl != null) {
      return ExtendedNetworkImageProvider(imageUrl);
    } else if (assetPath != null) {
      return ExtendedAssetImageProvider(assetPath);
    } else if (filePath != null) {
      if (kIsWeb) return ExtendedMemoryImageProvider(Uint8List.fromList([]));
      final dynamic f = utils_mobile.getFile(filePath); //workaround to allow compiling for web
      return ExtendedFileImageProvider(f);
    } else if (bytes != null) {
      return ExtendedMemoryImageProvider(bytes);
    } else {
      throw ArgumentError('At least one parameter must be filled');
    }
  }
}

img.Command? _createCommand(Uint8List? imageBytes, img.Image? image, String? filePath) {
  if (image != null) {
    return img.Command()..image(image);
  } else if (imageBytes != null) {
    return img.Command()..decodeImage(imageBytes);
  } else if (filePath != null) {
    return img.Command()..decodeImageFile(filePath);
  } else {
    return null;
  }
}
