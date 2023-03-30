import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:talk_ai/domain/entities/bot_message_stream_entity.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';
import 'package:talk_ai/domain/entities/system_message_entity.dart';
import 'package:talk_ai/domain/entities/user_message_entity.dart';
import 'package:talk_ai/infra/utils/get_message_from_api_chat_object_util.dart';

class SendMessageRepositoryImpl {
  static const _systemMessage = SystemMessageEntity(
      message:
          "Aja como se fosse um terapeuta em uma sessão, mas não minta sobre o que você é caso te perguntem. Sempre tente continuar a conversa a menos que o usuário termine a conversa verbalmente.");
  static const _okStatusCode = 200;

  Future<MessageEntity> call(List<MessageEntity> messageList) async {
    const key = String.fromEnvironment('CHAT_API_KEY');
    final messages = _messagesToAPI(messageList);
    final body = <String, dynamic>{
      "model": "gpt-3.5-turbo",
      "messages": messages,
      "stream": true,
    };

    final result = await Dio().post(
      'https://api.openai.com/v1/chat/completions',
      data: body,
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer $key',
        },
        responseType: ResponseType.stream,
      ),
    );
    if (result.statusCode != _okStatusCode) {
      throw Exception('Failed to send message');
    }
    final stream = (result.data.stream as Stream<Uint8List>)
        .asBroadcastStream()
        .map(_onStreamData);

    return BotMessageStreamEntity(
      message: "",
      messageStream: stream,
    );
  }

  List<Map<String, String>> _messagesToAPI(List<MessageEntity> messageList) {
    final List<MessageEntity> formattedMessageList =
        messageList.first is SystemMessageEntity
            ? messageList
            : [
                _systemMessage,
                ...messageList,
              ];

    return formattedMessageList.map(_convertMessageToRoleMessage).toList();
  }

  Map<String, String> _convertMessageToRoleMessage(MessageEntity message) {
    final role = message is UserMessageEntity
        ? 'user'
        : message is SystemMessageEntity
            ? 'system'
            : 'assistant';

    return {
      'role': role,
      'content': message.message,
    };
  }

  String _onStreamData(Uint8List event) {
    try {
      final decodedEvent = _convertBytesToString(event);

      if (decodedEvent.contains("data: [DONE]")) {
        return "";
      }
      final decodedMessageFormatted = _formatMessage(decodedEvent);
      final json = jsonDecode(decodedMessageFormatted);

      return getMessageFromStreamApiChatObjectUtil(json);
    } catch (e, s) {
      debugPrint("error: $e");
      debugPrint("stack: $s");
    }

    return "";
  }

  String _formatMessage(String text) {
    final textDividedByLines = text.trim().split("\n");
    final textDivided = textDividedByLines.length >= 3
        ? textDividedByLines[2]
        : textDividedByLines.first;
    final start = textDivided.indexOf("{");

    return textDivided.substring(start);
  }

  String _convertBytesToString(Uint8List bytes) {
    return Utf8Decoder().convert(bytes);
  }
}
