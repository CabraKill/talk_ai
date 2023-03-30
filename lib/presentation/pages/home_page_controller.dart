import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rive/rive.dart';
import 'package:talk_ai/data/repositories/send_message_stream_repository_impl.dart'
    if (dart.library.html) 'package:talk_ai/data/repositories/send_message_repository_impl.dart';
import 'package:talk_ai/domain/entities/bot_message_stream_entity.dart';
import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';
import 'package:talk_ai/domain/entities/homePageStates/idle_home_page_state.dart';
import 'package:talk_ai/domain/entities/homePageStates/receiving_message_home_page_state.dart';
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

  String _lastMessageWritten = '';
  bool _messageSent = false;

  void startMessaging() {
    final trigger = (_riveAnimationController?.findInput<bool>('startMessaging')
        as SMITrigger);
    trigger.fire();
  }

  void onInit(Artboard artboard) {
    final stateMachineController =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');
    _riveAnimationController = stateMachineController;
    final riveController = _riveAnimationController;
    if (riveController != null) {
      artboard.addController(riveController);
    }
  }

  void onChanged(String value) {
    if (value.contains("\n")) {
      return;
    }
    if (value.length == 1 && (_lastMessageWritten.isEmpty || _messageSent)) {
      startMessaging();
    } else if (value.isEmpty && !_messageSent) {
      _removeMessage();
    } else if (!_messageSent) {
      _startTyping();
    }
    _messageSent = false;
    _lastMessageWritten = value;
  }

  void onSendMessage({Function(String message)? onError}) {
    if (state is! IdleHomePageState) return;
    _messageSent = true;
    final text = textController.text;
    _sendMessageToAPI(text, onError: onError);
    textController.clear();
  }

  void init() {
    _updateState(
      newState: const IdleHomePageState.initial(),
    );
  }

  void onShareTap(MessageEntity botMessageEntity,
      void Function(String userMessage, String botMessage) share) {
    final messageList = state.messageList;

    final indexOfBotMessage = messageList.indexOf(botMessageEntity);
    final userMessageEntity = messageList[indexOfBotMessage - 1];
    final botMessage = botMessageEntity.message;
    final userMessage = userMessageEntity.message;
    share(
      userMessage,
      botMessage,
    );
  }

  void _updateState({
    HomePageState? newState,
  }) {
    if (newState != null) {
      state = newState;
    }
    notifyListeners();
  }

  void _sendMessageToAPI(
    String message, {
    Function(String message)? onError,
  }) async {
    final messageFormatted = message.trim();
    _updateStateToSending(messageFormatted);
    try {
      final result = await _sendMessageRepositoryImpl(state.messageList);
      _send();
      if (result is BotMessageStreamEntity) {
        _updateMessageToReceiving(result);
        final streamResult = await result.messageStream.drain();
        if (streamResult != null) {
          onError?.call(streamResult.toString());
        }
        _updateStateToIdle();
      } else {
        _addMessage(result);
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      onError?.call(e.toString());
    }
  }

  void _updateStateToSending(String messageFormatted) {
    _updateState(
      newState: SendingMessageHomePageState.fromState(
        state.addMessage(
          UserMessageEntity(
            message: messageFormatted,
          ),
        ),
      ),
    );
    _playLoadingAnimation();
  }

  void _addMessage(MessageEntity result) {
    _updateState(
        newState: IdleHomePageState.fromState(state.addMessage(result)));
  }

  void _updateMessageToReceiving(MessageEntity result) {
    _updateState(
        newState:
            ReceivingMessageHomePageState.fromState(state.addMessage(result)));
  }

  void _updateStateToIdle() {
    _updateState(
      newState: IdleHomePageState.fromState(state),
    );
  }

  void _startTyping() {
    final trigger = (_riveAnimationController?.findInput<bool>('startTyping')
        as SMITrigger);
    trigger.fire();
  }

  void _send() {
    final trigger = (_riveAnimationController?.findInput<bool>('sendMessage')
        as SMITrigger);
    trigger.fire();
  }

  void _playLoadingAnimation() {
    final trigger =
        (_riveAnimationController?.findInput<bool>('loading') as SMITrigger);
    trigger.fire();
  }

  void _removeMessage() {
    final trigger = (_riveAnimationController?.findInput<bool>('removeMessage')
        as SMITrigger);
    trigger.fire();
  }
}
