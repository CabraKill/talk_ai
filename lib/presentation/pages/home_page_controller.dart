import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rive/rive.dart';
import 'package:talk_ai/data/repositories/send_message_repository_impl.dart';
import 'package:talk_ai/domain/entities/bot_message_entity.dart';
import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';
import 'package:talk_ai/domain/entities/homePageStates/idle_home_page_state.dart';
import 'package:talk_ai/domain/entities/homePageStates/sending_message_home_page_state.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';
import 'package:talk_ai/domain/entities/user_message_entity.dart';

@injectable
class HomePageController extends ChangeNotifier {
  HomePageState state = const IdleHomePageState.initial();

  final textController = TextEditingController();

  StateMachineController? _riveAnimationController;

  final SendMessageRepositoryImpl _sendMessageRepositoryImpl =
      SendMessageRepositoryImpl();

  void _updateState({
    HomePageState? newState,
  }) {
    if (newState != null) {
      state = newState;
    }
    notifyListeners();
  }

  void startMessaging() {
    var trigger = (_riveAnimationController?.findInput<bool>('startMessaging')
        as SMITrigger);
    trigger.fire();
  }

  void _startTyping() {
    var trigger = (_riveAnimationController?.findInput<bool>('startTyping')
        as SMITrigger);
    trigger.fire();
  }

  void _send() {
    var trigger = (_riveAnimationController?.findInput<bool>('sendMessage')
        as SMITrigger);
    trigger.fire();
  }

  void _removeMessage() {
    var trigger = (_riveAnimationController?.findInput<bool>('removeMessage')
        as SMITrigger);
    trigger.fire();
  }

  void onInit(Artboard artboard) {
    _riveAnimationController =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')
            as StateMachineController;
    artboard.addController(_riveAnimationController!);
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      _removeMessage();
    } else {
      startMessaging();
      _startTyping();
    }
  }

  void onSendMessage({Function(String message)? onError}) {
    var text = textController.text;
    _sendMessageToAPI(text, onError: onError);
    textController.clear();
    _send();
  }

  void _sendMessageToAPI(String message,
      {Function(String message)? onError}) async {
    _updateState(
      newState: SendingMessageHomePageState.fromState(
        state.addMessage(
          UserMessageEntity(
            message: message,
          ),
        ),
      ),
    );
    try {
      final result = await _sendMessageRepositoryImpl(state.messageList);
      var botMessageEntity = BotMessageEntity(message: result);
      _updateMessage(botMessageEntity);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      onError?.call(e.toString());
    }
  }

  void _updateMessage(MessageEntity result) {
    _updateState(
        newState: IdleHomePageState.fromState(state.addMessage(result)));
  }

  void init() {
    _updateState(
      newState: const IdleHomePageState.initial(),
    );
  }
}