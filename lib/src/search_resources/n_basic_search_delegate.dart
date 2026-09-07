import 'package:diacritic/diacritic.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:search_resources/search_resources.dart';

import '../listresources/list_resources.dart';
import 'n_search_suggestion.dart';

class NBasicSearchDelegate(
  final Iterable<NSearchSuggestion> suggestions, {
  final BuildContext? actionContext,
}) extends SimpleSearchDelegate<Unit> {
  @override
  Widget buildSuggestions(BuildContext context) => _buildItems(context);

  @override
  Widget buildResults(BuildContext context) => _buildItems(context);

  Widget _buildItems(BuildContext context) {
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

  Widget _buildSuggestionTile(BuildContext searchContext, NSearchSuggestion item) {
    return item.tileBuilder?.call(searchContext) ??
        ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          onTap: () {
            close(searchContext, null);
            item.action(actionContext ?? searchContext);
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

sealed class _SearchListEntry();

final class const _GroupHeaderEntry(final String label) implements _SearchListEntry;

final class const _SuggestionEntry(final NSearchSuggestion suggestion) implements _SearchListEntry;

class const _GroupHeader({required final String label}) extends StatelessWidget {
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
