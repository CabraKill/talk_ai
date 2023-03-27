import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class ReceivingMessageHomePageState extends HomePageState {
  const ReceivingMessageHomePageState({
    required super.messageList,
  });

  @override
  factory ReceivingMessageHomePageState.fromState(HomePageState state) {
    return ReceivingMessageHomePageState(messageList: state.messageList);
  }

  @override
  ReceivingMessageHomePageState copyWith({
    List<MessageEntity>? messageList,
  }) {
    return ReceivingMessageHomePageState(
      messageList: messageList ?? this.messageList,
    );
  }
}
