import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class SendingMessageHomePageState extends HomePageState {
  const SendingMessageHomePageState({
    required super.messages,
  });

  @override
  factory SendingMessageHomePageState.fromState(HomePageState state) {
    return SendingMessageHomePageState(messages: state.messages);
  }

  @override
  SendingMessageHomePageState copyWith({
    List<MessageEntity>? messages,
  }) {
    return SendingMessageHomePageState(
      messages: messages ?? this.messages,
    );
  }
}
