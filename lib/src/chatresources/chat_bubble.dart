import 'package:bubble/bubble.dart';
import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import 'chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final double nipWidth;
  final EdgeInsets textPadding;

  const ChatBubble(
    this.message, {
    super.key,
    this.nipWidth = 12,
    this.textPadding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFF303030);

    return Bubble(
      margin: BubbleEdges.only(
        top: 2,
        left: message.fromMe ? 48 : 8,
        bottom: 2,
        right: message.fromMe ? 8 : 48,
      ),
      nip: message.fromMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      nipWidth: nipWidth,
      color: message.fromMe ? Colors.lightGreenAccent[100] : null,
      stick: true,
      alignment: message.fromMe ? Alignment.topRight : Alignment.topLeft,
      elevation: 4,
      child: DefaultTextStyle(
        style: context.textTheme.bodyMedium!,
        child: Padding(
          padding: textPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.showSender && message.sender != null)
                    Text(
                      message.sender ?? '',
                      style: TextStyle(fontSize: 14, color: textColor.withAlpha(150)),
                    ),
                  if (message.timestamp != null) ...[
                    Spacer(),
                    Text(
                      message.timestamp!.string('dd/MM/yyyy HH:mm'),
                      style: TextStyle(fontSize: 12, color: textColor.withAlpha(175)),
                    ),
                  ],
                ],
              ),
              message.child ?? message.message?.apply(Text.new) ?? SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
