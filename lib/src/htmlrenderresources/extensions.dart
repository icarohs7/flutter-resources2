import 'package:html_unescape/html_unescape.dart';

final _unescape = HtmlUnescape();

extension HtmlRenderExtension on String {
  String get htmlUnescaped => _unescape.convert(this);
}