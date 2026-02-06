import 'dart:convert';
import 'package:http/http.dart' as http;

class OnlineAIService {
  static const String _endpoint = "https://api.openai.com/v1/chat/completions";

  static Future<String> getResponse(String message) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer YOUR_API_KEY",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are BlueGuide, a coastal knowledge assistant for Indian coastal communities."
          },
          {"role": "user", "content": message}
        ]
      }),
    );

    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  }
}
