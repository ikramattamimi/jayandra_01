import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/user_model.dart';

class RegisterRepository {
  Future<http.Response> register(User user) async {
    return http.post(
      Uri.parse('http://localhost:3000/tambahData'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': user.email,
        'name': user.name,
        'password': user.password,
        'electricityClass': user.electricityclass,
      }),
    );
  }
}
