import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:search_resources/search_resources.dart';

import '../listresources/list_resources.dart';
import 'n_search_suggestion.dart';

class NBasicSearchDelegate extends SimpleSearchDelegate<Unit> {
  final Iterable<NSearchSuggestion> suggestions;

  NBasicSearchDelegate(this.suggestions);

  @override
  Widget buildSuggestions(BuildContext context) {
    sanitize(String input) => removeDiacritics(input.toLowerCase());
    itemMatches(NSearchSuggestion item) {
      final q = sanitize(query);
      return item.itemMatches?.call(query) ??
          (sanitize(item.title).contains(q) || sanitize(item.subtitle).contains(q));
    }

    final filtered = suggestions.where(itemMatches);
    final entries = _groupedEntries(filtered);

    return NListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, idx) {
        final entry = entries[idx];
        return switch (entry) {
          _GroupHeaderEntry(:final label) => _GroupHeader(label: label),
          _SuggestionEntry(:final suggestion) => _buildSuggestionTile(context, suggestion),
        };
      },
    );
  }

  Widget _buildSuggestionTile(BuildContext context, NSearchSuggestion item) {
    return item.tileBuilder?.call(context) ??
        ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          onTap: () {
            close(context, null);
            item.action(context);
          },
        );
  }
}

List<_SearchListEntry> _groupedEntries(Iterable<NSearchSuggestion> suggestions) {
  final entries = <_SearchListEntry>[];
  String? lastGroup;

  for (final item in suggestions) {
    final group = item.group;
    if (group != null && group != lastGroup) {
      entries.add(_GroupHeaderEntry(group));
      lastGroup = group;
    } else if (group == null) {
      lastGroup = null;
    }
    entries.add(_SuggestionEntry(item));
  }

  return entries;
}

sealed class _SearchListEntry {}

final class _GroupHeaderEntry implements _SearchListEntry {
  const _GroupHeaderEntry(this.label);

  final String label;
}

final class _SuggestionEntry implements _SearchListEntry {
  const _SuggestionEntry(this.suggestion);

  final NSearchSuggestion suggestion;
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const .fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: .bold),
      ),
    );
  }
}
