import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

/// Removes focus from any currently focused
/// widget
void clearFocus(BuildContext context) =>
    runCatching(() => FocusScope.of(context).requestFocus(FocusNode()));
