import 'package:flutter/material.dart';
import 'package:talk_ai/infra/design/design_colors.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message.dart';
import 'package:talk_ai/presentation/pages/home/widgets/user_message.dart';

class SharableContainer extends StatelessWidget {
  static const _source = "TalkAI - https://cabrakill.github.io/talk_ai/";

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
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            _source,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: DesignColors.cyan,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
