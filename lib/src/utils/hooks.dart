import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/widgets.dart';

/// Calculates height based on given aspect ratio and current widget width.
///
/// Takes [widthRatio] and [heightRatio] to calculate the aspect ratio.
/// Returns calculated height based on the current widget width and given ratio,
/// or null if the widget's RenderBox is not available.
///
/// Note: This hook uses post-frame rebuilding to ensure accurate measurements after layout.
///
/// Example:
/// ```dart
/// final height = useAspectRatioHeight(16, 9); // For 16:9 aspect ratio
/// ```
double? useAspectRatioHeight(double widthRatio, double heightRatio) {
  final size = useRenderBoxSize();
  final width = size?.width;
  if (width == null) return null;

  final ratio = heightRatio / widthRatio;
  return width * ratio;
}

/// Returns the size of the widget's RenderBox after layout.
///
/// This hook retrieves the widget's dimensions (width and height) after the layout
/// phase is complete using a post-frame callback. Returns null if the RenderBox
/// is not yet available.
///
/// Note: The size is only available after the first frame is rendered.
///
/// Example:
/// ```dart
/// final size = useRenderBoxSize();
/// if (size != null) {
///   print('Widget width: ${size.width}, height: ${size.height}');
/// }
/// ```
Size? useRenderBoxSize() {
  final context = useContext();
  final size = useState<Size?>(null);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.findRenderObject() case RenderBox rb) size.value = rb.size;
  });
  return size.value;
}

/// Executes a callback function on the next frame after the current build.
///
/// This hook uses [WidgetsBinding.addPostFrameCallback] to schedule the [callback]
/// to run after the current frame is rendered. This is useful for performing
/// actions that need to happen after the layout is complete.
///
/// Parameters:
/// - [callback]: The function to execute on the next frame.
/// - [keys]: Optional list of dependencies that will trigger the callback to be
///   rescheduled when they change.
///
/// Example:
/// ```dart
/// useOnNextFrame(() {
///   print('This will run after the frame is rendered');
/// });
/// ```
void useOnNextFrame(VoidCallback callback, [List<Object?>? keys]) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
    return null;
  }, keys);
}


/// Returns the current DateTime that automatically updates at a specified interval.
///
/// This hook provides a DateTime value that is periodically updated, allowing
/// widgets to rebuild with the current time. Useful for displaying clocks,
/// timestamps, or time-dependent UI elements.
///
/// Parameters:
/// - [interval]: The duration between updates. Defaults to 1 second.
///
/// Returns the current DateTime value that updates at the specified interval.
///
/// Example:
/// ```dart
/// final currentTime = useCurrentDateTime();
/// Text('Current time: ${currentTime.hour}:${currentTime.minute}:${currentTime.second}');
///
/// // Update every 100 milliseconds for more precision
/// final preciseTime = useCurrentDateTime(interval: Duration(milliseconds: 100));
/// ```
DateTime useCurrentDateTime({Duration interval = const Duration(seconds: 1)}) {
  final now = useState(DateTime.now());

  useEffect(() {
    final timer = Timer.periodic(interval, (_) => now.value = DateTime.now());
    return timer.cancel;
  }, [interval]);

  return now.value;
}
