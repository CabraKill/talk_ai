import 'package:flutter/material.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message.dart';
import 'package:talk_ai/presentation/pages/home/widgets/user_message.dart';

class SharableContainer extends StatelessWidget {
  const SharableContainer({
    super.key,
    required this.userMessage,
    required this.botMessage,
  });

  final String userMessage;
  final String botMessage;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserMessage(
                  message: userMessage,
                ),
                BotMessage(
                  message: botMessage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
