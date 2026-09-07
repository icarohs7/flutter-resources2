import 'package:bubble/bubble.dart';
import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import 'chat_message.dart';

class const ChatBubble(
  final ChatMessage message, {
  super.key,
  final double nipWidth = 12,
  final EdgeInsets textPadding = const .all(8),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFF303030);

    return Bubble(
      margin: .only(
        top: 2,
        left: message.fromMe ? 48 : 8,
        bottom: 2,
        right: message.fromMe ? 8 : 48,
      ),
      nip: message.fromMe ? .rightTop : .leftTop,
      nipWidth: nipWidth,
      color: message.fromMe ? Colors.lightGreenAccent[100] : null,
      stick: true,
      alignment: message.fromMe ? .topRight : .topLeft,
      elevation: 4,
      child: DefaultTextStyle(
        style: context.textTheme.bodyMedium!,
        child: Padding(
          padding: textPadding,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: <Widget>[
              Row(
                mainAxisSize: .min,
                children: [
                  if (message.showSender && message.sender != null)
                    Text(
                      message.sender ?? '',
                      style: .new(fontSize: 14, color: textColor.withAlpha(150)),
                    ),
                  if (message.timestamp != null) ...[
                    Spacer(),
                    Text(
                      message.timestamp!.string('dd/MM/yyyy HH:mm'),
                      style: .new(fontSize: 12, color: textColor.withAlpha(175)),
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
