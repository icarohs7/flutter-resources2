import 'package:material_ui/material_ui.dart';

class const DisposeAware({
  super.key,
  required final VoidCallback onDispose,
  required final Widget child,
}) extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _DisposeAwareState createState() => _DisposeAwareState();
}

class _DisposeAwareState() extends State<DisposeAware> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }
}
