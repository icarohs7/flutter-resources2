import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExtendedImageUtils {
  static Widget? ignoreErrorCallback(ExtendedImageState state) {
    return switch (state.extendedImageLoadState) {
      LoadState.failed => SizedBox(),
      _ => null,
    };
  }

  static loadUsingShimmerAndFailWith([Widget? onFailure]) {
    return (ExtendedImageState state) {
      return switch (state.extendedImageLoadState) {
        LoadState.loading => Skeletonizer(
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
        LoadState.failed => onFailure ?? SizedBox(),
        LoadState.completed => null,
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
