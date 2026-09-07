import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import '../classes/classes.dart';

class const NProvider<T>({
  required final T Function() instanceFactory,
  final void Function(T)? dispose,
  required final Widget Function(T) builder,
  final List<Object?> keys = const <Object?>[],
  super.key,
}) extends HookWidget {
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
