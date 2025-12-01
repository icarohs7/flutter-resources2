// ignore_for_file: constant_identifier_names
import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

const getIt = Core.get;

class NApp {
  static bool get isAndroid => defaultTargetPlatform == .android;

  static bool get isIOS => defaultTargetPlatform == .iOS;

  static bool get isWeb => kIsWeb;

  static bool get isWindows => defaultTargetPlatform == .windows;

  static bool get isMacOS => defaultTargetPlatform == .macOS;

  static bool get isLinux => defaultTargetPlatform == .linux;

  static bool get isFuchsia => defaultTargetPlatform == .fuchsia;

  static NOS get os {
    if (isAndroid) return .Android;
    if (isIOS) return .IOS;
    if (isWeb) return .Web;
    if (isWindows) return .Windows;
    if (isMacOS) return .MacOS;
    if (isLinux) return .Linux;
    if (isFuchsia) return .Fuchsia;
    return .Unknown;
  }
}

enum NOS {
  Android('Android'),
  IOS('iOS'),
  Windows('Windows'),
  MacOS('MacOS'),
  Linux('Linux'),
  Fuchsia('Fuchsia'),
  Web('Web'),
  Unknown('Unknown');

  const NOS(this.stringRepresentation);

  final String stringRepresentation;

  @override
  String toString() => stringRepresentation;
}
