import 'package:flutter/material.dart';

class DisposeAware extends StatefulWidget {
  const DisposeAware({super.key, required this.onDispose, required this.child});

  final VoidCallback onDispose;
  final Widget child;

  @override
  // ignore: library_private_types_in_public_api
  _DisposeAwareState createState() => _DisposeAwareState();
}

class _DisposeAwareState extends State<DisposeAware> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }
}
