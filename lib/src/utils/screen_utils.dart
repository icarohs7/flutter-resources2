import 'package:core_resources/core_resources.dart';
import 'package:flutter/services.dart';

abstract class ScreenUtils {
  static Future<void> lockOrientationToPortrait() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).orNull();
  }

  static Future<void> lockOrientationToLandscape() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).orNull();
  }
}
