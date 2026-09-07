import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

class const PinInput({
  super.key,
  required final TextEditingController controller,
  required final int length,
  final double cellSize = 44,
  final double spacing = 8,
  final BoxDecoration? decoration,
  final bool obscureText = false,
  final Widget? obscuringWidget,
  final String semanticsLabel = 'PIN',
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final value = useReactor(controller);
    final cellDecoration =
        decoration ??
        BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(cellSize / 2),
        );
    final filledLength = value.text.length > length ? length : value.text.length;

    return Semantics(
      container: true,
      label: semanticsLabel,
      value: '$filledLength/$length',
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: <Widget>[
          for (int index = 0; index < length; index++) ...[
            if (index > 0) SizedBox(width: spacing),
            SizedBox(
              key: ValueKey('pin-input-cell-$index'),
              width: cellSize,
              height: cellSize,
              child: DecoratedBox(
                decoration: cellDecoration,
                child: Center(
                  child: index >= filledLength
                      ? null
                      : obscureText
                      ? obscuringWidget ??
                            Container(
                              width: cellSize * 0.5,
                              height: cellSize * 0.5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(cellSize * 0.25),
                              ),
                            )
                      : Text(value.text[index]),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
