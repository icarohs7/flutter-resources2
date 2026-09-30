import 'package:core_resources/core_resources.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// A scaffold with an optional floating bottom-navigation overlay.
///
/// When [floatingBottomNav] is enabled, the bottom navigation is rendered over
/// the body and its measured height is added to [MediaQuery.padding.bottom].
/// Scroll views that read that padding can therefore keep their final content
/// above the overlay. Snackbars are shown above the navigation.
class const NSimpleScaffold({
  super.key,
  final String? title,
  final PreferredSizeWidget? appBar,
  final List<Widget>? appBarActions,
  required final Widget body,
  final PreferredSizeWidget? bottom,
  final String? heroTag,
  final Widget? bottomNavigationBar,
  final Widget? floatingActionButton,
  final FloatingActionButtonLocation? floatingActionButtonLocation,
  final Widget? drawer,
  final Widget? endDrawer,
  final bool? resizeToAvoidBottomInset,
  final Color? backgroundColor,

  /// Whether [bottomNavigationBar] should float over the body.
  ///
  /// When false, the navigation bar uses [Scaffold.bottomNavigationBar]'s
  /// normal layout and the floating action button uses the standard scaffold
  /// placement.
  final bool floatingBottomNav = true,
}) extends HookWidget {
  this : assert(!(title != null && appBar != null));

  @override
  Widget build(BuildContext context) {
    final useFloatingOverlay = floatingBottomNav && bottomNavigationBar != null;
    final navigationHeight = useState(0.0);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final bottomViewPadding = MediaQuery.viewPaddingOf(context).bottom;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final resolvedBody = useFloatingOverlay
        ? _FloatingBody(
            body: body,
            bottomNavigationBar: bottomNavigationBar!,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            bottomPadding: bottomPadding,
            bottomViewPadding: bottomViewPadding,
            onNavigationHeightChanged: (height) => navigationHeight.value = height,
          )
        : body;

    return Scaffold(
      appBar: (title == null && appBar == null)
          ? null
          : appBar ??
                _AppBar(
                  title: title,
                  appBarActions: appBarActions,
                  heroTag: heroTag,
                  bottom: bottom,
                ),
      body: resolvedBody,
      // Scaffold lays snackbars out above this slot, so an empty box as tall as the floating
      // navigation keeps them off it. While the keyboard is shorter than the box, Scaffold
      // would keep the extended body, and the navigation with it, behind the keyboard.
      bottomNavigationBar: useFloatingOverlay
          ? SizedBox(height: keyboardVisible ? 0 : bottomPadding + navigationHeight.value)
          : bottomNavigationBar,
      floatingActionButton: useFloatingOverlay ? null : floatingActionButton,
      floatingActionButtonLocation: useFloatingOverlay ? null : floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      extendBody: true,
    );
  }
}

class const _FloatingBody({
  required final Widget body,
  required final Widget bottomNavigationBar,
  final Widget? floatingActionButton,
  final FloatingActionButtonLocation? floatingActionButtonLocation,
  required final double bottomPadding,
  required final double bottomViewPadding,
  required final void Function(double height) onNavigationHeightChanged,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final overlayHeight = useState(0.0);
    // The scaffold replaces the body's bottom insets with the height of its navigation slot.
    final scaffoldMediaQuery = MediaQuery.of(context);
    final mediaQuery = scaffoldMediaQuery.copyWith(
      padding: scaffoldMediaQuery.padding.copyWith(bottom: bottomPadding),
      viewPadding: scaffoldMediaQuery.viewPadding.copyWith(bottom: bottomViewPadding),
    );
    final bodyMediaQuery = mediaQuery.copyWith(
      padding: mediaQuery.padding.copyWith(bottom: bottomPadding + overlayHeight.value),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(data: bodyMediaQuery, child: body),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MediaQuery(
            data: mediaQuery,
            child: SafeArea(
              left: false,
              top: false,
              right: false,
              bottom: true,
              child: _SizeReporter(
                onSizeChanged: (size) {
                  if (!context.mounted || size.height == overlayHeight.value) return;
                  overlayHeight.value = size.height;
                },
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    if (floatingActionButton != null)
                      Align(
                        alignment: _fabAlignment(floatingActionButtonLocation),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: floatingActionButton,
                        ),
                      ),
                    _SizeReporter(
                      onSizeChanged: (size) {
                        if (context.mounted) onNavigationHeightChanged(size.height);
                      },
                      child: bottomNavigationBar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Alignment _fabAlignment(FloatingActionButtonLocation? location) {
    return switch (location) {
      FloatingActionButtonLocation.centerFloat ||
      FloatingActionButtonLocation.centerDocked ||
      FloatingActionButtonLocation.centerTop ||
      FloatingActionButtonLocation.miniCenterFloat ||
      FloatingActionButtonLocation.miniCenterDocked ||
      FloatingActionButtonLocation.miniCenterTop => Alignment.bottomCenter,
      FloatingActionButtonLocation.startFloat ||
      FloatingActionButtonLocation.startDocked ||
      FloatingActionButtonLocation.startTop ||
      FloatingActionButtonLocation.miniStartFloat ||
      FloatingActionButtonLocation.miniStartDocked ||
      FloatingActionButtonLocation.miniStartTop => Alignment.bottomLeft,
      _ => Alignment.bottomRight,
    };
  }
}

class const _SizeReporter({
  required final void Function(Size size) onSizeChanged,
  required super.child,
}) extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderSizeReporter(final void Function(Size size) initialCallback) extends RenderProxyBox {
  void Function(Size size) onSizeChanged = initialCallback;

  Size? _reportedSize;

  @override
  void performLayout() {
    super.performLayout();
    if (_reportedSize == size) return;

    _reportedSize = size;
    WidgetsBinding.instance.addPostFrameCallback((_) => onSizeChanged(size));
  }
}

class const _AppBar({
  final String? title,
  final String? heroTag,
  final PreferredSizeWidget? bottom,
  final List<Widget>? appBarActions,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: heroTag != null
          ? Hero(
              tag: heroTag!,
              child: Material(
                color: Colors.transparent,
                child: Text(title ?? '', style: Theme.of(context).primaryTextTheme.titleLarge),
              ),
            )
          : Text(title ?? ''),
      actions: appBarActions,
      bottom: bottom,
      centerTitle: true,
    );
  }
}
