import 'package:flutter/material.dart';
import 'package:talk_ai/domain/entities/bot_message_stream_entity.dart';
import 'package:talk_ai/presentation/pages/home/widgets/message_container.dart';

class BotMessageStreamBuilder extends StatelessWidget {
  final BotMessageStreamEntity message;
  const BotMessageStreamBuilder({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: message.messageStream,
      builder: (context, snap) {
        final messageText = message.message;

        return MessageContainer(
          message: messageText,
          color: Colors.purple,
        );
      },
    );
  }
}
