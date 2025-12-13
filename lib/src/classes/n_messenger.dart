import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';

/// A utility class that provides global access to showing messages and dialogs.
///
/// This class cannot be instantiated and only provides static methods and properties
/// for managing global messaging and dialog functionality.
abstract class NMessenger {
  /// Global key for accessing the [ScaffoldMessenger] state throughout the app.
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Global key for accessing the [Navigator] state throughout the app.
  static final navigatorKey = GlobalKey<NavigatorState>();

  static ScaffoldMessengerState? get _state => scaffoldMessengerKey.currentState;

  static BuildContext? get _context => navigatorKey.currentContext;

  /// Shows a snackbar using the global [ScaffoldMessenger].
  ///
  /// Returns a [ScaffoldFeatureController] that can be used to control the snackbar,
  /// or null if the scaffold messenger is not available.
  ///
  /// Parameters:
  ///   * [snackbar] - The [SnackBar] widget to display.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackbar(
    SnackBar snackbar,
  ) => _state?.showSnackBar(snackbar);

  /// Shows a dialog using the global navigator.
  ///
  /// Returns a [Future] that resolves to the value passed to [Navigator.pop]
  /// when the dialog is closed, or null if the navigator is not available.
  ///
  /// Parameters:
  ///   * [builder] - Builder function that creates the dialog widget.
  ///   * [barrierDismissible] - Whether dialog can be dismissed by tapping barrier.
  ///   * [barrierColor] - Color of the modal barrier.
  ///   * [barrierLabel] - Semantic label for the barrier.
  ///   * [useSafeArea] - Whether to ensure dialog is inside system UI safe area.
  ///   * [useRootNavigator] - Whether to show dialog above all other routes.
  ///   * [routeSettings] - Settings for the dialog route.
  ///   * [anchorPoint] - Position where the dialog originates from.
  ///   * [traversalEdgeBehavior] - Behavior when reaching edge during traversal.
  ///   * [fullscreenDialog] - Whether this dialog takes up the full screen.
  ///   * [requestFocus] - Whether to request focus when the route is pushed.
  ///   * [animationStyle] - Style of dialog's entrance/exit animations.
  static Future<T?> showDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    bool fullscreenDialog = false,
    bool? requestFocus,
    AnimationStyle? animationStyle,
  }) async {
    final context = _context;
    if (context == null) return null;

    return m.showDialog(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
      fullscreenDialog: fullscreenDialog,
      requestFocus: requestFocus,
      animationStyle: animationStyle,
    );
  }
}
