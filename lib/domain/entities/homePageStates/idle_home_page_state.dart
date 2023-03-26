import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';

class IdleHomePageState extends HomePageState {
  const IdleHomePageState({
    required super.messageList,
  });

  const IdleHomePageState.initial() : super(messageList: const []);

  factory IdleHomePageState.fromState(HomePageState state) {
    return IdleHomePageState(messageList: state.messageList);
  }

  @override
  List<Object> get props => [];
}
