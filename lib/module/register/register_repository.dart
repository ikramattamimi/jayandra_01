import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class RegisterRepository {
  Future<http.Response> register(UserModel user) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/tambahData'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': user.email,
        'name': user.name,
        'password': user.password,
      }),
    );
  }
}
