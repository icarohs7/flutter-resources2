import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

class DoubleBackToCloseApp extends HookWidget {
  final SnackBar snackBar;
  final Widget child;

  const DoubleBackToCloseApp({required this.snackBar, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (Scaffold.maybeOf(context) == null) {
        throw FlutterError('`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.');
      }
      return true;
    }());

    final snackBarVisible = useState(false);
    final snackBarEpoch = useRef(0);

    if (Theme.of(context).platform != TargetPlatform.android) {
      return child;
    }

    final willHandlePopInternally = ModalRoute.of(context)?.willHandlePopInternally ?? false;

    return PopScope(
      canPop: snackBarVisible.value || willHandlePopInternally,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        final epoch = ++snackBarEpoch.value;
        snackBarVisible.value = true;
        unawaited(
          messenger.showSnackBar(snackBar).closed.then((_) {
            if (context.mounted && snackBarEpoch.value == epoch) {
              snackBarVisible.value = false;
            }
          }),
        );
      },
      child: child,
    );
  }
}
