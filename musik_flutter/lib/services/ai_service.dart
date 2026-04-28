import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AIService {
  static const String _url = 'http://192.168.1.104:3000/api/chat';

  Future<String> getChatResponse(String message) async {
    try {
      final response = await http
          .post(
            Uri.parse(_url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"message": message}),
          )
          .timeout(const Duration(seconds: 30));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'] ?? "AI tidak memberikan jawaban.";
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return "Error: ${errorData['result'] ?? 'Gagal memproses pesan'}";
        } catch (_) {
          return "Server bermasalah (Status: ${response.statusCode})";
        }
      }
    } on TimeoutException catch (_) {
      return "Koneksi lemot: Request waktu habis. Coba lagi.";
    } on http.ClientException catch (e) {
      print("ClientException: $e");
      return "Gagal terhubung ke server. Cek IP & Wi-Fi.";
    } catch (e) {
      print("ERROR: $e");
      return "Terjadi kesalahan: $e";
    }
  }
}
