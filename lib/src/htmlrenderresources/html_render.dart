import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../adapters/adapters.dart';
import 'extensions.dart';

class HtmlRender extends StatelessWidget {
  const HtmlRender({super.key, required this.data, this.style, this.extensions = const []});

  final String data;
  final Map<String, Style>? style;
  final List<HtmlExtension> extensions;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = context.getInheritedWidgetOfExactType<MediaQuery>();
    final mediaQueryData = mediaQuery?.data ?? .fromView(View.of(context));

    return MediaQuery(
      data: mediaQueryData,
      child: Html(
        data: data.htmlUnescaped,
        style: {...?style},
        onLinkTap: (url, attributes, element) {
          if (url != null) launchUrl(Uri.parse(url));
        },
        extensions: extensions,
      ),
    );
  }
}
