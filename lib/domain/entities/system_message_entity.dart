import 'dart:typed_data';

import 'package:talk_ai/domain/entities/message_entity.dart';

class SystemMessageEntity implements MessageEntity {
  @override
  final String message;

  @override
  final Stream<Uint8List>? messageStream;

  const SystemMessageEntity({
    required this.message,
    this.messageStream,
  });
}
