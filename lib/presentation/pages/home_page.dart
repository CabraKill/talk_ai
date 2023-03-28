import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_ai/domain/entities/bot_message_stream_entity.dart';
import 'package:talk_ai/domain/entities/homePageStates/idle_home_page_state.dart';
import 'package:talk_ai/domain/entities/user_message_entity.dart';
import 'package:talk_ai/infra/services/theme_service.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message.dart';
import 'package:talk_ai/presentation/pages/home/widgets/bot_message_stream_builder.dart';
import 'package:talk_ai/presentation/pages/home/widgets/send_button.dart';
import 'package:talk_ai/presentation/pages/home/widgets/user_message.dart';
import 'package:talk_ai/presentation/pages/home_page_controller.dart';
import 'package:talk_ai/presentation/pages/info/info_dialog.dart';
import 'package:talk_ai/presentation/pages/share/share_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _pagePadding = 8.0;
  static const double _fieldDimension = 52;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageController>().init();
    });
    _showInfoDialogInStartUp();
  }

  void _showErrorSnackBar(String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
      ),
    );
  }

  void _showInfoDialogInStartUp() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _showInfoDialog();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => ChatGPTDialog(),
    );
  }

  void _share(
    String userMessage,
    String botMessage,
  ) {
    showDialog(
      context: context,
      builder: (_) => ShareDialog(
        userMessage: userMessage,
        botMessage: botMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final outlineBorder = inputDecorationTheme.outlineBorder;
    const disabledBorderColor = Colors.purple;
    final borderColor = outlineBorder?.color ?? Colors.grey;
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: outlineBorder?.width ?? 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );

    return Consumer<ThemeService>(builder: (context, themeController, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('TalkAI'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: _showInfoDialog,
            ),
            IconButton(
              icon: Icon(
                themeController.isDarkTheme
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: themeController.toggle,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: _pagePadding,
            right: _pagePadding,
            bottom: _pagePadding,
          ),
          child: Consumer<HomePageController>(
              builder: (context, controller, child) {
            final isReady = controller.state is IdleHomePageState;
            final messageList = controller.state.messageList;

            final onSendButtonTap = isReady ? controller.onSendMessage : null;
            final onInit = controller.onInit;

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
                                (messageEntity) =>
                                    messageEntity is UserMessageEntity
                                        ? UserMessage(
                                            message: messageEntity.message,
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: messageEntity
                                                        is BotMessageStreamEntity
                                                    ? BotMessageStreamBuilder(
                                                        message: messageEntity,
                                                      )
                                                    : BotMessage(
                                                        message: messageEntity
                                                            .message,
                                                      ),
                                              ),
                                              const SizedBox(width: 16),
                                              IconButton(
                                                icon: const Icon(Icons.share),
                                                onPressed: () => controller
                                                    .onShareTap(messageEntity, _share),
                                              ),
                                            ],
                                          ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              labelText: 'Message',
                            ),
                            maxLines: 5,
                            minLines: 1,
                            controller: controller.textController,
                            onChanged: controller.onChanged,
                            onSubmitted: (_) => controller.onSendMessage(
                                onError: _showErrorSnackBar),
                            textInputAction: TextInputAction.send,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SendButton(
                            onSendButtonTap: onSendButtonTap,
                            fieldDimension: _fieldDimension,
                            isReady: isReady,
                            borderColor: borderColor,
                            disabledBorderColor: disabledBorderColor,
                            onInit: onInit),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
