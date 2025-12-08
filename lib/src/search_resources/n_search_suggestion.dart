import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'n_search_suggestion.freezed.dart';

@freezed
abstract class NSearchSuggestion with _$NSearchSuggestion {
  const factory NSearchSuggestion({
    required String title,
    required String subtitle,
    required void Function(BuildContext context) action,
    Widget Function(BuildContext context)? tileBuilder,
  }) = _NSearchSuggestion;
}
