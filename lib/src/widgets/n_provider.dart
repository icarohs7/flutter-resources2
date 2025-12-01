import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import '../classes/classes.dart';

class NProvider<T> extends HookWidget {
  const NProvider({required this.instance, this.dispose, required this.builder, super.key});

  final T instance;
  final void Function(T)? dispose;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return () {
        final value = instance;
        if (value is Disposable) value.onDispose();
        dispose?.call(value);
        if (value is Disposable || dispose != null) clog('$value -> disposed');
      };
    }, []);

    return builder(instance);
  }
}
