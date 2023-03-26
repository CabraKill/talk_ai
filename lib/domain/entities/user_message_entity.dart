import 'package:talk_ai/domain/entities/message_entity.dart';

class UserMessageEntity implements MessageEntity {
  @override
  final String message;

  const UserMessageEntity({
    required this.message,
  });
}
