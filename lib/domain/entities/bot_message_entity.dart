import 'package:talk_ai/domain/entities/message_entity.dart';

class BotMessageEntity implements MessageEntity {
  @override
  final String message;

  const BotMessageEntity({
    required this.message,
  });
}
