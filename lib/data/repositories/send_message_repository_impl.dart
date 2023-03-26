import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

part 'key.dart';

class SendMessageRepositoryImpl {
  Future<String> call(String question) async {
    var body = <String, dynamic>{
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
    };
    final result = await Dio().post(
      'https://api.openai.com/v1/chat/completions',
      data: body,
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer $_key',
          },
      ),
    );
    if (result.statusCode != 200) {
      throw Exception('Failed to send message');
    }
    return result.data['choices'][0]['message']['content'];
  }
}
