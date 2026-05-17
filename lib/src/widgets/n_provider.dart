import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import '../classes/classes.dart';

class NProvider<T> extends HookWidget {
  final T Function() instanceFactory;
  final void Function(T)? dispose;
  final Widget Function(T) builder;
  final List<Object?> keys;

  const NProvider({
    required this.instanceFactory,
    this.dispose,
    required this.builder,
    this.keys = const <Object?>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final instance = useMemoized(instanceFactory, keys);

    useEffect(() {
      return () {
        final value = instance;
        if (value is Disposable) value.onDispose();
        dispose?.call(value);
        if (value is Disposable || dispose != null) clog('$value -> disposed');
      };
    }, keys);

    return builder(instance);
  }
}
