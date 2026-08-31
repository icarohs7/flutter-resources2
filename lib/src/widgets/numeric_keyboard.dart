import 'package:material_ui/material_ui.dart';

typedef KeyboardTapCallback = void Function(String text);

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
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
      alignment: Alignment.center,
      child: Column(
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
    return OverflowBar(alignment: alignment, children: children);
  }
}

class const _NumericKeyboardKey({
  required final String value,
  required final ValueChanged<String> onTap,
  required final Color textColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () => onTap(value),
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        child: Text(
          value,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}

class const _NumericKeyboardAction({required final Icon? icon, required final Function()? onTap})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: onTap == null ? null : () => onTap!(),
      child: Container(alignment: Alignment.center, width: 50, height: 50, child: icon),
    );
  }
}
