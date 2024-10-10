// ignore_for_file: constant_identifier_names
import 'dart:io';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

const getIt = Core.get;

class NApp {
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isWeb => kIsWeb;

  static NOS get os {
    if (isAndroid) return NOS.Android;
    if (isIOS) return NOS.IOS;
    if (isWindows) return NOS.Windows;
    if (isMacOS) return NOS.MacOS;
    if (isWeb) return NOS.Web;
    return NOS.Unknown;
  }
}

enum NOS {
  Android('Android'),
  IOS('iOS'),
  Windows('Windows'),
  MacOS('MacOS'),
  Web('Web'),
  Unknown('Unknown');

  const NOS(this.stringRepresentation);

  final String stringRepresentation;

  @override
  String toString() => stringRepresentation;
}
