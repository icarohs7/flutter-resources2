import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:launch_app_store/launch_app_store.dart' as store_redirect;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> redirectToStore({String? androidAppId, String? iosAppId}) =>
    store_redirect.LaunchReview.launch(androidAppId: androidAppId, iOSAppId: iosAppId);

Future<bool> launchUrl(Uri url, {bool openOnWebView = false}) => url_launcher.launchUrl(url,
    mode: openOnWebView
        ? url_launcher.LaunchMode.inAppWebView
        : url_launcher.LaunchMode.externalApplication);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(SnackBar snackbar) {
  return Asuka.showSnackBar(snackbar);
}
