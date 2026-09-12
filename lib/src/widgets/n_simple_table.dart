import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import '../extensions/extensions.dart';
import '../listresources/list_resources.dart';

/// A compact, scrollable table with a styled header and alternating rows.
class const NSimpleTable({
  super.key,
  required final List<NTableColumn> columns,
  required final int rowCount,
  required final List<Widget> Function(BuildContext context, int index) rowBuilder,
  final bool shrinkWrap = false,
  final ScrollPhysics? physics,
  final EdgeInsetsGeometry? cellPadding = const EdgeInsets.all(8),
}) extends StatelessWidget {
  List<Widget> _header() {
    return columns
        .map((column) => Text(column.title, style: .new(fontWeight: .bold, fontSize: 16)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return NListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: rowCount + 1,
      itemBuilder: (ctx, index) {
        final cells = index == 0 ? _header() : rowBuilder(ctx, index - 1);

        return Container(
          color: context.theme.colorScheme.primary.withAlphaDecimal(
            index == 0
                ? 0.5
                : index.isEven
                ? 0.2
                : 0.1,
          ),
          padding: cellPadding,
          child: Row(
            children: cells
                .mapIndexed(
                  (cellIndex, cell) => Expanded(flex: columns[cellIndex].size, child: cell),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

/// Describes a table column and its relative width.
class const NTableColumn({required final String title, required final int size});
