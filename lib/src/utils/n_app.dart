// ignore_for_file: constant_identifier_names
import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

const getIt = Core.get;

class NApp {
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isWeb => kIsWeb;

  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

  static NOS get os {
    if (isAndroid) return NOS.Android;
    if (isIOS) return NOS.IOS;
    if (isWeb) return NOS.Web;
    if (isWindows) return NOS.Windows;
    if (isMacOS) return NOS.MacOS;
    if (isFuchsia) return NOS.Fuchsia;
    return NOS.Unknown;
  }
}

enum NOS {
  Android('Android'),
  IOS('iOS'),
  Windows('Windows'),
  MacOS('MacOS'),
  Fuchsia('Fuchsia'),
  Web('Web'),
  Unknown('Unknown');

  const NOS(this.stringRepresentation);

  final String stringRepresentation;

  @override
  String toString() => stringRepresentation;
}
