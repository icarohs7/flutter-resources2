import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import '../listresources/list_resources.dart';
import 'chat_bubble.dart';
import 'chat_message.dart';

/// Scrollable chat layout with a reverse message list and optional composer.
///
/// Messages are rendered through [messageBuilder] inside [ChatBubble] widgets
/// in a reverse [NListView], so the newest items sit at the bottom of the
/// viewport. When [messageCount] is zero, [messageWhenEmpty] is shown centered
/// over the list when provided.
///
/// When [onSubmit] is non-null, a multiline [TextFormField] and
/// [LoadingFloatingActionButton] are shown below the list. Tapping send runs
/// [validator] (if any); [onSubmit] is called only when validation passes.
/// The composer is disabled when [enabled] is false or [isLoading] is true.
///
/// Pass [messageController] to control the text field from outside; otherwise
/// an internal [TextEditingController] is created.
class Chat extends StatelessWidget {
  /// External controller for the composer. When null, an internal controller is used.
  final TextEditingController? messageController;

  /// Number of messages passed to [NListView.builder].
  final int? messageCount;

  /// Builds the [ChatMessage] displayed at [index].
  final ChatMessage Function(BuildContext context, int index) messageBuilder;

  /// When true, the send button shows a loading state and the field is disabled.
  final bool isLoading;

  /// Called with the trimmed composer text when send is pressed and validation passes.
  /// When null, the composer row is hidden.
  final void Function(String message)? onSubmit;

  /// Optional validation run before [onSubmit]. Return false to block submission.
  final bool Function(String? message)? validator;

  /// Hint text for the composer [TextFormField].
  final String? fieldHint;

  /// Message shown centered in the list when [messageCount] is zero.
  final String? messageWhenEmpty;

  /// When false, the composer field and send button are disabled.
  final bool enabled;

  /// Vertical sizing of the root [Column].
  final MainAxisSize mainAxisSize;

  Chat({
    super.key,
    this.messageController,
    this.messageCount,
    required this.messageBuilder,
    this.isLoading = false,
    this.onSubmit,
    this.validator,
    this.fieldHint,
    this.messageWhenEmpty,
    this.enabled = true,
    this.mainAxisSize = .max,
  });

  late final textController = messageController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              NListView.builder(
                reverse: true,
                itemCount: messageCount,
                itemBuilder: (ctx, idx) => ChatBubble(messageBuilder(ctx, idx)),
              ),
              if (messageCount == 0)
                if (messageWhenEmpty != null)
                  Center(
                    child: Padding(
                      padding: const .all(8),
                      child: Text(messageWhenEmpty!, style: TextStyle(fontSize: 16)),
                    ),
                  )
                else
                  SizedBox(),
            ],
          ),
        ),
        if (onSubmit != null)
          Padding(
            padding: const .all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    minLines: 1,
                    maxLines: 999,
                    enabled: enabled && !isLoading,
                    decoration: InputDecoration(
                      hintText: fieldHint,
                      border: OutlineInputBorder(borderRadius: .circular(32)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                LoadingFloatingActionButton(
                  isLoading: isLoading,
                  shape: CircleBorder(),
                  onPressed: !enabled
                      ? null
                      : () {
                          final message = textController.text;
                          if (validator?.call(message) ?? true) {
                            onSubmit?.call(message);
                          }
                        },
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
