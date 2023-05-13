import 'dart:convert';
import 'package:http/http.dart' as http;

class CekEmailRepository {
  Future<http.Response> cekEmail(String? email) async {
    return http.post(
      Uri.parse('http://localhost:3000/cekEmail'),
      // Uri.parse('http://192.168.198.8:3000/login'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
      }),
    );
  }
}
