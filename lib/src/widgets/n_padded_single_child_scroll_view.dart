import 'package:material_ui/material_ui.dart';

/// A [SingleChildScrollView] that defaults to the current bottom safe-area inset.
///
/// An explicit [padding] is preserved. When it is omitted, the widget uses
/// [MediaQuery.paddingOf(context).bottom] as bottom padding so content stays
/// visible above bottom system UI and floating overlays.
class const NPaddedSingleChildScrollView({
  final ScrollController? controller,
  final ScrollPhysics? physics,
  final Axis scrollDirection = Axis.vertical,
  final EdgeInsetsGeometry? padding,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics,
      scrollDirection: scrollDirection,
      padding: padding ?? .only(bottom: MediaQuery.paddingOf(context).bottom),
      child: child,
    );
  }
}
