import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'n_animated_list_item.dart';
import 'n_padded_custom_scroll_view.dart';
import 'n_sliver_list_with_empty.dart';

/// A refreshable list with empty, animated-item, and optional load-more states.
///
/// [emptyListFallbackText] and [loadMoreLabel] are explicit so the widget can
/// be used by applications with different languages and copy conventions.
class const NRefreshListView<T>({
  super.key,
  final Future<void> Function()? onRefresh,
  required final Iterable<T> items,
  final Widget Function(BuildContext, int index)? separatorBuilder,
  required final Widget Function(BuildContext, int index, T item) itemBuilder,
  required final String emptyListFallbackText,
  final Widget? emptyListFallbackWidget,
  final EdgeInsets? listPadding,
  final Widget? header,
  final Widget? footer,
  final ScrollPhysics? physics,
  final bool shrinkWrap = false,
  final FutureOr<void> Function()? onLoadMore,
  final FutureOr<void> Function()? afterLoadMore,
  final bool? enableLoadMore,
  final bool? waitingLoadMore,
  required final String loadMoreLabel,
  final bool animateItems = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemList = items.toList();

    return _OptionalRefreshIndicator(
      onRefresh: onRefresh,
      child: NPaddedCustomScrollView(
        shrinkWrap: shrinkWrap,
        physics: physics,
        slivers: [
          NSliverListWithEmpty<T>(
            emptyListFallbackWidget: emptyListFallbackWidget,
            emptyListFallbackText: emptyListFallbackText,
            listPadding: listPadding,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final child = itemBuilder(context, index, itemList[index]);
              if (!animateItems) return child;
              return NAnimatedListItem(index: index, child: child);
            },
            separatorBuilder: separatorBuilder,
            afterLoadMore: afterLoadMore,
            enableLoadMore: enableLoadMore,
            loadMoreLabel: loadMoreLabel,
            onLoadMore: onLoadMore,
            waitingLoadMore: waitingLoadMore,
            sliverHeader: header == null ? null : SliverToBoxAdapter(child: header),
            sliverFooter: footer == null ? null : SliverToBoxAdapter(child: footer),
          ),
        ],
      ),
    );
  }
}

class const _OptionalRefreshIndicator({
  required final Widget child,
  final RefreshCallback? onRefresh,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return onRefresh == null ? child : RefreshIndicator(onRefresh: onRefresh!, child: child);
  }
}
