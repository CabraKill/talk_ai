import 'package:flutter/material.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';

class BotMessageStreamEntity implements MessageEntity {
  @override
  String message;

  final Stream<String> messageStream;

  BotMessageStreamEntity({
    required this.message,
    required this.messageStream,
  }) {
    messageStream.listen(
      _onStreamData,
      onDone: _onStreamDone,
      onError: _onErrorStream,
    );
  }

  void _onErrorStream(error) {
    debugPrint("stream error: $error");
  }

  void _onStreamDone() {
    debugPrint("stream closed");
  }

  void _onStreamData(String character) {
    message += character;
  }
}
