import 'package:flutter/material.dart';

import 'n_basic_search_delegate.dart';
import 'n_search_suggestion.dart';

class NInputSearchBar extends StatelessWidget {
  final Iterable<NSearchSuggestion> suggestions;
  final String? searchHint;
  final ShapeBorder? shape;
  final double? elevation;
  final Widget? icon;

  const NInputSearchBar({
    required this.suggestions,
    this.searchHint,
    this.shape,
    this.elevation,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(vertical: 8, horizontal: 24),
      child: Material(
        elevation: elevation ?? 6,
        shape: shape ?? StadiumBorder(),
        child: InkWell(
          onTap: () => showSearch(context: context, delegate: NBasicSearchDelegate(suggestions)),
          customBorder: shape ?? StadiumBorder(),
          child: Row(
            children: [
              Padding(
                padding: .symmetric(vertical: 8, horizontal: 16),
                child: icon ?? Icon(Icons.search),
              ),
              Expanded(
                child: Padding(
                  padding: .symmetric(vertical: 16, horizontal: 8),
                  child: Text(
                    searchHint ?? 'Pesquisar',
                    style: TextStyle(fontSize: 18, fontWeight: .bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
