import 'package:talk_ai/domain/entities/homePageStates/home_page_state.dart';

class IdleHomePageState extends HomePageState {
  const IdleHomePageState({
    required super.messages,
  });

  const IdleHomePageState.initial() : super(messages: const []);

  factory IdleHomePageState.fromState(HomePageState state) {
    return IdleHomePageState(messages: state.messages);
  }

  @override
  List<Object> get props => [];
}
