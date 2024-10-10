import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

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

class NSelectionPage<T> extends StatelessWidget {
  final String? title;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  const NSelectionPage({
    this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title?.apply((title) {
        return AppBar(
          title: Text(title),
          centerTitle: true,
        );
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
