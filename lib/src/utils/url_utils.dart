import 'package:core_resources/core_resources.dart';

/// Extracts the base url from the
/// given url
/// ```
/// baseUrlFrom('https://github.com/api)
/// // Returns: github.com
/// ```
String baseUrlFrom(String url) {
  return url
      .replaceAll('https://', '')
      .replaceAll('http://', '')
      .apply((url) => url.substring(0, url.indexOf('/')));
}
