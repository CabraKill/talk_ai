import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:talk_ai/domain/entities/bot_message_stream_entity.dart';
import 'package:talk_ai/domain/entities/homePageStates/idle_home_page_state.dart';
import 'package:talk_ai/domain/entities/user_message_entity.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message_stream_builder.dart';
import 'package:talk_ai/presentation/pages/home/widgets/user_message.dart';
import 'package:talk_ai/presentation/pages/home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _pagePadding = 8.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: _pagePadding,
          right: _pagePadding,
          bottom: _pagePadding,
        ),
        child:
            Consumer<HomePageController>(builder: (context, controller, child) {
          final isReady = controller.state is IdleHomePageState;
          final messageList = controller.state.messageList;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: messageList.isEmpty ? FlexFit.loose : FlexFit.tight,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: messageList
                            .map(
                              (message) => message is UserMessageEntity
                                  ? UserMessage(
                                      message: message,
                                    )
                                  : message is BotMessageStreamEntity
                                      ? BotMessageStreamBuilder(
                                          message: message,
                                        )
                                      : BotMessage(
                                          message: message,
                                        ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          labelText: 'Message',
                        ),
                        controller: controller.textController,
                        onChanged: controller.onChanged,
                        onSubmitted: (_) => controller.onSendMessage(
                            onError: _showErrorSnackBar),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: isReady ? controller.onSendMessage : null,
                      child: SizedBox.square(
                        dimension: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isReady ? Colors.black : Colors.black38,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: RiveAnimation.asset(
                            "assets/rive/chat.riv",
                            fit: BoxFit.cover,
                            artboard: "enterChat",
                            onInit: controller.onInit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showErrorSnackBar(String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
      ),
    );
  }
}
