import 'package:material_ui/material_ui.dart';

typedef KeyboardTapCallback = void Function(String text);

const _keyMinHeight = 72.0;

/// A simple numeric keyboard with optional left and right action buttons.
class const NumericKeyboard({
  super.key,
  required final KeyboardTapCallback onKeyboardTap,
  final Color textColor = Colors.black,
  final Function()? rightButtonFn,
  final Icon? rightIcon,
  final Function()? leftButtonFn,
  final Icon? leftIcon,
  final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceEvenly,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Column(
        mainAxisSize: .min,
        children: <Widget>[
          _NumericKeyboardRow(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _NumericKeyboardKey(value: '1', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '2', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '3', onTap: onKeyboardTap, textColor: textColor),
            ],
          ),
          _NumericKeyboardRow(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _NumericKeyboardKey(value: '4', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '5', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '6', onTap: onKeyboardTap, textColor: textColor),
            ],
          ),
          _NumericKeyboardRow(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _NumericKeyboardKey(value: '7', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '8', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardKey(value: '9', onTap: onKeyboardTap, textColor: textColor),
            ],
          ),
          _NumericKeyboardRow(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _NumericKeyboardAction(icon: leftIcon, onTap: leftButtonFn),
              _NumericKeyboardKey(value: '0', onTap: onKeyboardTap, textColor: textColor),
              _NumericKeyboardAction(icon: rightIcon, onTap: rightButtonFn),
            ],
          ),
        ],
      ),
    );
  }
}

class const _NumericKeyboardRow({
  required final MainAxisAlignment alignment,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [for (final child in children) Expanded(child: child)],
    );
  }
}

class const _NumericKeyboardKey({
  required final String value,
  required final ValueChanged<String> onTap,
  required final Color textColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NumericKeyboardHitTarget(
      onTap: () => onTap(value),
      child: Text(
        value,
        style: .new(fontSize: 26, fontWeight: .bold, color: textColor),
      ),
    );
  }
}

class const _NumericKeyboardAction({required final Icon? icon, required final VoidCallback? onTap})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NumericKeyboardHitTarget(onTap: onTap, child: icon);
  }
}

class const _NumericKeyboardHitTarget({
  required final VoidCallback? onTap,
  required final Widget? child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _keyMinHeight),
        child: Center(child: child),
      ),
    );
  }
}
