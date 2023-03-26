import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class SendingMessageHomePageState extends HomePageState {
  const SendingMessageHomePageState({
    required super.messageList,
  });

  @override
  factory SendingMessageHomePageState.fromState(HomePageState state) {
    return SendingMessageHomePageState(messageList: state.messageList);
  }

  @override
  SendingMessageHomePageState copyWith({
    List<MessageEntity>? messageList,
  }) {
    return SendingMessageHomePageState(
      messageList: messageList ?? this.messageList,
    );
  }
}
