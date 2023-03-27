import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';
import 'package:talk_ai/infra/utils/get_message_from_api_chat_object_util.dart';

class BotMessageStreamEntity implements MessageEntity {
  @override
  final String message;

  String latestMessage = '';

  @override
  final Stream<Uint8List>? messageStream;

  BotMessageStreamEntity({
    required this.message,
    this.messageStream,
  }) {
    latestMessage = message;
    messageStream?.listen(
      _onStreamData,
      onDone: _onStreamDone,
      onError: _onErrorStream,
    );
  }

  void _onStreamData(Uint8List event) {
    try {
      final decodedEvent = _convertBytesToString(event);

      if (decodedEvent.contains("data: [DONE]")) {
        return;
      }
      var decodedMessageFormatted =
          _removeInitialDataTextInTheBeginning(decodedEvent);
      final message = getMessageFromStreamApiChatObjectUtil(
        jsonDecode(decodedMessageFormatted),
      );
      latestMessage += message;
    } catch (e, s) {
      debugPrint("error: $e");
      debugPrint("stack: $s");
    }
  }

  String _removeInitialDataTextInTheBeginning(String text) {
    return text.substring(6).trim();
  }

  String _convertBytesToString(Uint8List bytes) {
    return Utf8Decoder().convert(bytes);
  }

  void _onErrorStream(error) {
    debugPrint("stream error: $error");
  }

  void _onStreamDone() {
    debugPrint("stream closed");
  }
}
