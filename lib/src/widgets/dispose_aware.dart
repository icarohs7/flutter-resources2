import 'package:flutter/material.dart';

class DisposeAware extends StatefulWidget {
  const DisposeAware({super.key, required this.onDispose, required this.child});

  final VoidCallback onDispose;
  final Widget child;

  @override
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
