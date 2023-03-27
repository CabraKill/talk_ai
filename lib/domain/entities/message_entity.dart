import 'dart:typed_data';

abstract class MessageEntity {
  final String message;
  final Stream<Uint8List>? messageStream;

  const MessageEntity({
    required this.message,
    this.messageStream,
  });
}
