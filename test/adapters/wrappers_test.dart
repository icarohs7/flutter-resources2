import 'package:flutter/services.dart';
import 'package:flutter_resources2/src/adapters/wrappers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  late _FakeUrlLauncher fake;
  late UrlLauncherPlatform originalInstance;

  setUp(() {
    originalInstance = UrlLauncherPlatform.instance;
    fake = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = fake;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalInstance;
  });

  group('launchUrl', () {
    final url = Uri(scheme: 'https', host: 'example.com');

    test('returns true when url launcher succeeds', () async {
      fake.launchResult = true;

      expect(await launchUrl(url), isTrue);
    });

    test('returns false when url launcher returns false', () async {
      fake.launchResult = false;

      expect(await launchUrl(url), isFalse);
    });

    test('uses external application launch mode by default', () async {
      await launchUrl(url);

      expect(fake.lastLaunchMode, PreferredLaunchMode.externalApplication);
    });

    test('uses in-app web view launch mode when openOnWebView is true', () async {
      await launchUrl(url, openOnWebView: true);

      expect(fake.lastLaunchMode, PreferredLaunchMode.inAppWebView);
    });

    test('returns false when activity is not found', () async {
      fake.launchException = PlatformException(code: 'ACTIVITY_NOT_FOUND');

      expect(await launchUrl(url), isFalse);
    });

    test('rethrows other platform exceptions', () async {
      fake.launchException = PlatformException(code: 'OTHER');

      expect(launchUrl(url), throwsA(isA<PlatformException>()));
    });
  });
}

class _FakeUrlLauncher extends Fake with MockPlatformInterfaceMixin implements UrlLauncherPlatform {
  PreferredLaunchMode? lastLaunchMode;
  bool launchResult = true;
  Exception? launchException;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    lastLaunchMode = options.mode;
    if (launchException != null) {
      throw launchException!;
    }
    return launchResult;
  }

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async => launchResult;

  @override
  Future<void> closeWebView() async {}

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async => true;

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async => true;
}
