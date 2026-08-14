import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// Removes focus from any currently focused
/// widget
void clearFocus(BuildContext context) =>
    runCatching(() => FocusScope.of(context).requestFocus(FocusNode()));
