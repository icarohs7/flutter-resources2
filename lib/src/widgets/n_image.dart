import 'dart:typed_data';

import 'package:core_resources/core_resources.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class NImage extends StatelessWidget {
  final String? url;
  final String? asset;
  final Uint8List? bytes;
  final ImageProvider? imageProvider;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final BoxFit? fit;
  final BoxConstraints? constraints;
  final LoadStateChanged? loadStateChanged;
  final Widget? onFailureFallback;
  final Color? color;
  final BoxShape? shape;

  const NImage({
    this.url,
    this.asset,
    this.bytes,
    this.imageProvider,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.fit,
    this.constraints,
    this.loadStateChanged,
    this.onFailureFallback,
    this.color,
    this.shape,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? getProvider() {
      if (url case String url) {
        return ExtendedNetworkImageProvider(url, printError: false);
      } else if (asset case String assetName) {
        return ExtendedAssetImageProvider(assetName);
      } else if (bytes case Uint8List bytes) {
        return ExtendedMemoryImageProvider(bytes);
      } else {
        return null;
      }
    }

    return switch (imageProvider ?? getProvider()) {
      ImageProvider provider => ExtendedImage(
          image: provider,
          width: width,
          height: height,
          alignment: alignment,
          fit: fit,
          constraints: constraints,
          color: color,
          loadStateChanged: loadStateChanged ??
              onFailureFallback?.apply((f) => ExtendedImageUtils.loadUsingShimmerAndFailWith(f)) ??
              ExtendedImageUtils.loadUsingShimmerAndFailWith(),
          shape: shape,
        ),
      _ => SizedBox(width: width, height: height),
    };
  }
}
