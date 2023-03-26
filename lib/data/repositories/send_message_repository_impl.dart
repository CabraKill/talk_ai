import 'package:dio/dio.dart';
import 'package:talk_ai/domain/entities/message_entity.dart';
import 'package:talk_ai/domain/entities/system_message_entity.dart';
import 'package:talk_ai/domain/entities/user_message_entity.dart';

class SendMessageRepositoryImpl {
  static const _systemMessage = SystemMessageEntity(
      message:
          "Aja como se fosse um terapeuta em uma sessão, mas não minta sobre o que você é caso te perguntem. Sempre tente continuar a conversa a menos que o usuário termine a conversa verbalmente.");
  Future<String> call(List<MessageEntity> messageList) async {
    const key = String.fromEnvironment('CHAT_API_KEY');
    var messages = _messagesToAPI(messageList);
    var body = <String, dynamic>{
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
    if (result.statusCode != 200) {
      throw Exception('Failed to send message');
    }
    return result.data['choices'][0]['message']['content'];
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
