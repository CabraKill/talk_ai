String getMessageFromApiChatObjectUtil(Map<String, dynamic> apiChatObject) {
  return apiChatObject['choices'][0]['message']?['content'];
}

String getMessageFromStreamApiChatObjectUtil(Map<String, dynamic> apiChatObject) {
  return apiChatObject['choices'][0]['delta']?['content'] ?? '';
}