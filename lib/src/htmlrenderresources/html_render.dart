import 'package:material_ui/material_ui.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../adapters/adapters.dart';
import 'extensions.dart';

class const HtmlRender({super.key, required final String data}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = context.getInheritedWidgetOfExactType<MediaQuery>();
    final mediaQueryData = mediaQuery?.data ?? .fromView(View.of(context));

    return MediaQuery(
      data: mediaQueryData,
      child: HtmlWidget(
        data.htmlUnescaped,
        onTapUrl: (url) async {
          await launchUrl(.parse(url));
          return true;
        },
        renderMode: .column,
      ),
    );
  }
}
