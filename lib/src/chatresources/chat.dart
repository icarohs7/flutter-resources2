import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import '../listresources/list_resources.dart';
import 'chat_bubble.dart';
import 'chat_message.dart';

class Chat extends StatelessWidget {
  final TextEditingController? messageController;
  final int? messageCount;
  final ChatMessage Function(BuildContext context, int index) messageBuilder;
  final bool isLoading;
  final void Function(String message)? onSubmit;
  final bool Function(String? message)? validator;
  final String? fieldHint;
  final String? messageWhenEmpty;
  final bool enabled;

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
    this.mainAxisSize = MainAxisSize.max,
  });

  final MainAxisSize mainAxisSize;

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
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        messageWhenEmpty!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                else
                  SizedBox(),
            ],
          ),
        ),
        if (onSubmit != null)
          Padding(
            padding: const EdgeInsets.all(8),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
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
