import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/utils/network_api.dart';

class CekEmailRepository {
  Future<http.Response> cekEmail(String? email) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/cekEmail'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, String?>{
        'email': email,
      }),
    );
  }
}
