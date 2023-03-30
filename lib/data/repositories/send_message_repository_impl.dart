import 'package:dio/dio.dart';
import 'package:talk_ai/domain/entities/bot_message_entity.dart';
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
    };
    final result = await Dio().post(
      'https://api.openai.com/v1/chat/completions',
      data: body,
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer $key',
        },
      ),
    );
    if (result.statusCode != _okStatusCode) {
      throw Exception('Failed to send message');
    }

    return BotMessageEntity(
      message: getMessageFromApiChatObjectUtil(result.data),
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
}
