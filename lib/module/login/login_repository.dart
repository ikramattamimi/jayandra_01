import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<http.Response> login(String? email, String? password) async {
    return http.post(
      Uri.parse('http://localhost:3000/login'),
      // Uri.parse('http://192.168.198.8:3000/login'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
        'password': password,
      }),
      // body: {
      //   'email': email,
      //   'password': password,
      // },
    );
  }
}
