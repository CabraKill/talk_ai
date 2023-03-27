import 'dart:typed_data';

import 'package:talk_ai/domain/entities/message_entity.dart';

class BotMessageEntity implements MessageEntity {
  @override
  final String message;

  @override
  final Stream<Uint8List>? messageStream;

  const BotMessageEntity({
    required this.message,
    this.messageStream,
  });
}
