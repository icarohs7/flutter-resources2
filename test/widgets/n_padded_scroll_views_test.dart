import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('appends bottom sliver padding from MediaQuery', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(bottom: 24)),
          child: NPaddedCustomScrollView(
            slivers: const [SliverToBoxAdapter(child: Text('Content'))],
          ),
        ),
      ),
    );

    final scrollView = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
    expect(scrollView.slivers, hasLength(2));
    expect(scrollView.slivers.last, isA<SliverPadding>());
    expect((scrollView.slivers.last as SliverPadding).padding, const EdgeInsets.only(bottom: 24));
  });

  testWidgets('does not append padding after a non-scrolling SliverFillRemaining', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NPaddedCustomScrollView(
          slivers: const [SliverFillRemaining(hasScrollBody: false, child: Text('Content'))],
        ),
      ),
    );

    final scrollView = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
    expect(scrollView.slivers, hasLength(1));
    expect(scrollView.slivers.single, isA<SliverFillRemaining>());
  });

  testWidgets('uses the bottom safe-area inset for a single-child scroll view', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(bottom: 18)),
          child: NPaddedSingleChildScrollView(child: Text('Content')),
        ),
      ),
    );

    final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    expect(scrollView.padding, const EdgeInsets.only(bottom: 18));
  });
}
