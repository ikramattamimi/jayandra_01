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
  Future<http.Response> changePassword(String? email, String? password) async {
    return http.put(
      Uri.parse('${NetworkAPI.ip}/changePassword/$email'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'password': password,
      }),
    );
  }
  Future<http.Response> changeName(String? email, String? name) async {
    return http.put(
      Uri.parse('${NetworkAPI.ip}/updateUser/$email'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'name': name,
      }),
    );
  }
}
