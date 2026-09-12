import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A title that fades in near the collapsed state of a flexible sliver app bar.
class const NSliverAppBarTitle({required final Widget child, super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final opacity = useState(1.0);
    final barSettings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    useEffect(() {
      final settings = barSettings;
      if (settings != null) {
        final alpha = settings.minExtent / settings.currentExtent;
        opacity.value = alpha > .7 ? alpha : 0;
      }

      return null;
    }, [barSettings]);

    return AnimatedOpacity(opacity: opacity.value, duration: .new(milliseconds: 50), child: child);
  }
}
