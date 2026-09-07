import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import '../listresources/list_resources.dart';

Future<T?> showSelectionFullscreenDialog<T>(
  BuildContext context, {
  String? title,
  required int itemCount,
  required NullableIndexedWidgetBuilder itemBuilder,
  IndexedWidgetBuilder? separatorBuilder,
}) async {
  return await Nav.to.goFullscreenDialog<T>(
    context,
    page: NSelectionPage(
      title: title,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
    ),
  );
}

class const NSelectionPage<T>({
  final String? title,
  required final int itemCount,
  required final NullableIndexedWidgetBuilder itemBuilder,
  final IndexedWidgetBuilder? separatorBuilder,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title?.apply((title) {
        return AppBar(title: Text(title), centerTitle: true);
      }),
      body: CustomScrollView(
        slivers: [
          NSliverList.separated(
            itemCount: itemCount,
            separatorBuilder: separatorBuilder ?? (context, index) => Divider(),
            itemBuilder: itemBuilder,
          ),
        ],
      ),
    );
  }
}
