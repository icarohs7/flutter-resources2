import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final sourceItems = [3, 5, 8, 13];

  Widget itemBuilder(BuildContext context, int index, int item) {
    return ListTile(title: Text('$item'));
  }

  NRefreshListView<int> list({
    Iterable<int>? items,
    Future<void> Function()? onRefresh,
    Widget? emptyListFallbackWidget,
    String? emptyListFallbackText,
    FutureOr<void> Function()? onLoadMore,
    FutureOr<void> Function()? afterLoadMore,
    bool? enableLoadMore,
    bool? waitingLoadMore,
    bool animateItems = true,
  }) {
    return NRefreshListView(
      animateItems: animateItems,
      items: items ?? sourceItems,
      itemBuilder: itemBuilder,
      onRefresh: onRefresh,
      emptyListFallbackText: emptyListFallbackText ?? 'Nothing found',
      emptyListFallbackWidget: emptyListFallbackWidget,
      enableLoadMore: enableLoadMore,
      waitingLoadMore: waitingLoadMore,
      onLoadMore: onLoadMore,
      afterLoadMore: afterLoadMore,
      loadMoreLabel: 'Load more',
    );
  }

  testWidgets('shows items', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: list(animateItems: false))));

    expect(find.byType(ListTile), findsNWidgets(4));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('13'), findsOneWidget);
  });

  testWidgets('animates items by default and can disable animation', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: list())));
    expect(find.byType(NAnimatedListItem), findsNWidgets(4));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: list(animateItems: false))));
    expect(find.byType(NAnimatedListItem), findsNothing);
  });

  testWidgets('shows the configured empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(items: const [], emptyListFallbackText: 'Nothing here'),
        ),
      ),
    );
    expect(find.text('Nothing here'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(
            items: const [],
            emptyListFallbackWidget: ListTile(
              title: Text('Custom empty state'),
              subtitle: Icon(Icons.close),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Custom empty state'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('calls the refresh callback', (tester) async {
    var refreshCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(
            onRefresh: () async {
              refreshCount++;
            },
          ),
        ),
      ),
    );

    final state = tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator));
    state.show();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(refreshCount, 1);
  });

  testWidgets('shows and gates the load-more action', (tester) async {
    var count = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(
            animateItems: false,
            enableLoadMore: true,
            waitingLoadMore: false,
            onLoadMore: () {
              count += 'a';
            },
            afterLoadMore: () {
              count += 'z';
            },
          ),
        ),
      ),
    );

    expect(find.text('Load more'), findsOneWidget);
    await tester.tap(find.text('Load more'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(count, 'az');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(items: const [], enableLoadMore: true, onLoadMore: () {}),
        ),
      ),
    );
    expect(find.text('Load more'), findsNothing);
  });

  testWidgets('shows the load-more spinner', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: list(
            animateItems: false,
            enableLoadMore: true,
            waitingLoadMore: true,
            onLoadMore: () {},
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
