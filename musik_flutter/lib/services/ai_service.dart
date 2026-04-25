import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  static const String _url = 'http://10.0.2.2:3000/api/chat';

  Future<String> getChatResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'];
      } else {
        final errorData = jsonDecode(response.body);
        return "Server Error: ${errorData['result']}";
      }
    } catch (e) {
      return "Koneksi Gagal: Pastikan Node.js sudah jalan.";
    }
  }
}
