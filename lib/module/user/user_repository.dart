import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/utils/network_api.dart';

class UserRepository {
  Future<http.Response> login(String? email, String? password) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/login'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
        'password': password,
      }),
    );
  }
}
