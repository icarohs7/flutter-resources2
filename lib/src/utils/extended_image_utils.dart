import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExtendedImageUtils {
  static Widget? ignoreErrorCallback(ExtendedImageState state) {
    return switch (state.extendedImageLoadState) {
      .failed => SizedBox(),
      _ => null,
    };
  }

  static loadUsingShimmerAndFailWith([Widget? onFailure]) {
    return (ExtendedImageState state) {
      return switch (state.extendedImageLoadState) {
        .loading => Skeletonizer(
          enabled: true,
          enableSwitchAnimation: true,
          child: Skeleton.leaf(
            child: Container(
              color: Colors.grey,
              width: state.extendedImageInfo?.image.width.toDouble(),
              height: state.extendedImageInfo?.image.height.toDouble(),
            ),
          ),
        ),
        .failed => onFailure ?? SizedBox(),
        .completed => null,
      };
    };
  }

  static ImageProvider switchProvider(
    bool condition,
    ImageProvider whenTrue,
    ImageProvider whenFalse,
  ) {
    return condition ? whenTrue : whenFalse;
  }
}
