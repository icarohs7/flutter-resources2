import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:search_resources/search_resources.dart';

import '../extensions/extensions.dart';
import '../listresources/list_resources.dart';
import 'n_search_suggestion.dart';

class NBasicSearchDelegate extends SimpleSearchDelegate<Unit> {
  final Iterable<NSearchSuggestion> suggestions;

  NBasicSearchDelegate(this.suggestions);

  @override
  Widget buildSuggestions(BuildContext context) {
    sanitize(String input) => removeDiacritics(input.toLowerCase());
    final filtered = suggestions.where((item) => sanitize(item.title).contains(sanitize(query)));

    return NListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, idx) {
        final item = filtered[idx];
        return item.tileBuilder?.call(context) ??
            ListTile(
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              onTap: () {
                close(context, null);
                item.action(context);
              },
            );
      },
    );
  }
}
