import 'package:flutter/material.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';
import 'package:talk_ai/presentation/pages/home/widgets/message_container.dart';

class BotMessage extends StatelessWidget {
  final MessageEntity message;
  const BotMessage({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
      message: message.message,
      color: Colors.purple,
    );
  }
}