import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import '../listresources/n_sliver_list.dart';
import 'n_no_items_tile.dart';

/// Renders a list sliver with an empty state and optional load-more action.
///
/// [emptyListFallbackText] and [loadMoreLabel] are explicit so this generic
/// widget does not impose application-specific copy.
class const NSliverListWithEmpty<T>({
  super.key,
  final int? itemCount,
  final Widget? Function(BuildContext, int index)? itemBuilder,
  final Widget? Function(BuildContext, int index)? separatorBuilder,
  required final String emptyListFallbackText,
  final Widget? emptyListFallbackWidget,
  final EdgeInsets? listPadding,
  final Widget? sliverHeader,
  final Widget? sliverFooter,
  final FutureOr<void> Function()? onLoadMore,
  final FutureOr<void> Function()? afterLoadMore,
  final bool? enableLoadMore,
  final bool? waitingLoadMore,
  required final String loadMoreLabel,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isEmpty = itemCount == 0;
    final loadMoreActive = !isEmpty && (enableLoadMore ?? false) && onLoadMore != null;

    Future<void> loadMore() async {
      await onLoadMore?.call();
      await afterLoadMore?.call();
    }

    return SliverMainAxisGroup(
      slivers: [
        ?sliverHeader,
        if (isEmpty)
          SliverFillRemaining(
            child: Center(
              child: emptyListFallbackWidget ?? NNoItemsTile(noItemsText: emptyListFallbackText),
            ),
          )
        else
          _SliverListChild(
            listPadding: listPadding,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder,
          ),
        if (loadMoreActive)
          SliverToBoxAdapter(
            child: LoadingTextButton(
              isLoading: waitingLoadMore ?? false,
              onPressed: loadMore,
              child: Text(loadMoreLabel),
            ),
          ),
        ?sliverFooter,
      ],
    );
  }
}

class const _SliverListChild({
  final int? itemCount,
  final Widget? Function(BuildContext, int index)? separatorBuilder,
  final Widget? Function(BuildContext, int index)? itemBuilder,
  final EdgeInsets? listPadding,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemBuilder = this.itemBuilder;
    final separatorBuilder = this.separatorBuilder;

    Widget? buildItem(BuildContext context, int index) => itemBuilder?.call(context, index);

    final sliver = separatorBuilder != null
        ? NSliverList.separated(
            itemCount: itemCount,
            separatorBuilder: separatorBuilder,
            itemBuilder: buildItem,
          )
        : NSliverList.builder(itemCount: itemCount, itemBuilder: buildItem);

    return listPadding == null ? sliver : SliverPadding(padding: listPadding!, sliver: sliver);
  }
}
