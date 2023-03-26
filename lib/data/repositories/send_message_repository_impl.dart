import 'dart:convert';

import 'package:http/http.dart' as http;

part 'key.dart';

class SendMessageRepositoryImpl {
  Future<String> call(String question) async {
    var body = jsonEncode(<String, dynamic>{
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "Aja como se fosse um terapeuta em uma sessão, mas não minta sobre o que você é caso te perguntem.",
        },
        {
          "role": "user",
          "content": question,
        },
      ],
    });
    final messagem = """{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "Hello!"}]
  }""";
    final result = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_key',
        'content-enconding': 'br',
        // "accept-language": "pt-BR,pt;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
      },
      body: body,
    );
    if (result.statusCode != 200) {
      throw Exception('Failed to send message');
    }
    var message = _decodeResponse(result.body);
    return message;
  }

  String _decodeResponse(String response) {
    var body = jsonDecode(response);
    print(body);
    var choices = body['choices'];
    var message = choices[0]['message'];
    return message["content"];
  }

  String _getTheResponse(List messageList) {
    var message = messageList[messageList.length - 1];
    return message;
  }
}
