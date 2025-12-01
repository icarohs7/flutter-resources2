import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:store_redirect/store_redirect.dart' as store_redirect;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> redirectToStore({String? androidAppId, String? iosAppId}) =>
    store_redirect.StoreRedirect.redirect(androidAppId: androidAppId, iOSAppId: iosAppId);

Future<bool> launchUrl(Uri url, {bool openOnWebView = false}) =>
    url_launcher.launchUrl(url, mode: openOnWebView ? .inAppWebView : .externalApplication);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(SnackBar snackbar) {
  return Asuka.showSnackBar(snackbar);
}

Future<ShareResult> share(ShareParams params) {
  return share_plus.SharePlus.instance.share(params);
}

typedef ShareParams = share_plus.ShareParams;
typedef ShareResult = share_plus.ShareResult;
