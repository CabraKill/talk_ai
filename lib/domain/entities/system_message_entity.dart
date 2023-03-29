import 'package:talk_ai/domain/entities/message_entity.dart';

class SystemMessageEntity implements MessageEntity {
  @override
  final String message;

  const SystemMessageEntity({
    required this.message,
  });
}
