import 'package:equatable/equatable.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class HomePageState extends Equatable {
  final List<MessageEntity> messageList;

  @override
  List<Object> get props => [messageList];

  const HomePageState({
    required this.messageList,
  });

  factory HomePageState.fromState(HomePageState state) {
    return state.copyWith();
  }
  
  HomePageState addMessage(MessageEntity message) {
    return copyWith(messageList: [
      ...messageList,
      message,
    ]);
  }

  HomePageState copyWith({
    List<MessageEntity>? messageList,
  }) {
    return HomePageState(
      messageList: messageList ?? this.messageList,
    );
  }

}
