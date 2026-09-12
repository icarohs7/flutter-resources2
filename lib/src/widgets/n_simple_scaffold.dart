import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// A scaffold with an optional floating bottom-navigation overlay.
///
/// When [floatingBottomNav] is enabled, the bottom navigation is rendered over
/// the body and its measured height is added to [MediaQuery.padding.bottom].
/// Scroll views that read that padding can therefore keep their final content
/// above the overlay.
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
}) extends StatelessWidget {
  this : assert(!(title != null && appBar != null));

  @override
  Widget build(BuildContext context) {
    final useFloatingOverlay = floatingBottomNav && bottomNavigationBar != null;
    final resolvedBody = useFloatingOverlay
        ? _FloatingBody(
            body: body,
            bottomNavigationBar: bottomNavigationBar!,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
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
      bottomNavigationBar: useFloatingOverlay ? null : bottomNavigationBar,
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

class _FloatingBody extends StatefulWidget {
  const _FloatingBody({
    required this.body,
    required this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget body;
  final Widget bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<_FloatingBody> createState() => _FloatingBodyState();
}

class _FloatingBodyState extends State<_FloatingBody> {
  double _overlayHeight = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyMediaQuery = mediaQuery.copyWith(
      padding: mediaQuery.padding.copyWith(bottom: mediaQuery.padding.bottom + _overlayHeight),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(data: bodyMediaQuery, child: widget.body),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            left: false,
            top: false,
            right: false,
            bottom: true,
            child: _SizeReporter(
              onSizeChanged: _updateOverlayHeight,
              child: Column(
                mainAxisSize: .min,
                children: [
                  if (widget.floatingActionButton != null)
                    Align(
                      alignment: _fabAlignment(widget.floatingActionButtonLocation),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: widget.floatingActionButton,
                      ),
                    ),
                  widget.bottomNavigationBar,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateOverlayHeight(Size size) {
    if (!mounted || size.height == _overlayHeight) return;
    setState(() => _overlayHeight = size.height);
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

class _SizeReporter extends SingleChildRenderObjectWidget {
  const _SizeReporter({required this.onSizeChanged, required super.child});

  final void Function(Size size) onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onSizeChanged);

  void Function(Size size) onSizeChanged;
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
