import 'package:equatable/equatable.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class HomePageState extends Equatable {
  final List<MessageEntity> messages;
  const HomePageState({
    required this.messages,
  });

  HomePageState addMessage(MessageEntity message) {
    return copyWith(messages: [
      ...messages,
      message,
    ]);
  }

  HomePageState copyWith({
    List<MessageEntity>? messages,
  }) {
    return HomePageState(
      messages: messages ?? this.messages,
    );
  }

  factory HomePageState.fromState(HomePageState state) {
    return state.copyWith();
  }

  @override
  List<Object> get props => [messages];
}
