import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_therapy/main/model/message.dart';

class ChatService {
  // HTTP request method to send a message to the large model
  static Future<Message> sendMessage(String userId, String content, bool isFirstMessage) async {
    String requestContent = "";
    if (isFirstMessage) {
      requestContent += "问题：请问您现在的心情用以下哪一点描述比较合适？\n 1. 欢快 \n 2. 平静 \n 3. 悲郁 \n 4. 其它，请言明\n";
    }
    requestContent += content;

    try {
      final response = await http.post(
        Uri.parse('http://wasabi'),
        body: jsonEncode(<String, String>{
          'userId': userId,
          'content': requestContent,
        }),
      );

      if (response.statusCode == 200) {
        final message = Message.fromJson(jsonDecode(response.body));
        return message;
      } else {
        throw Exception("Response returned status code: ${response.statusCode}");
      }
    } on Exception {
      return Message(text: "好的。下面，请描述你当前的心情。");
      // FIXME: This is debug code.
    }
  }
}
