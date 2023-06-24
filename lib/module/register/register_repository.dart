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

  Future<http.Response> sendOTP(String email) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/send-otp'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
      }),
    );
  }
  
  Future<http.Response> verifyOTP(String email, String otp) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/verify-otp'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
        'otp': otp,
      }),
    );
  }
}
