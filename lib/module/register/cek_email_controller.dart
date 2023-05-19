import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/register/cek_email_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CekEmailController {
  CekEmailRepository _repository = CekEmailRepository();

  bool isLoading = false;
  var emailController = TextEditingController();

  Future<MyResponse> cekEmail() async {
    http.Response result = await _repository.cekEmail(emailController.text);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

      if (myResponse.code == 0) {
        final prefs = await SharedPreferences.getInstance();

        // simpan token
        // await prefs.setString('token', myResponse.data?.token ?? "");
        // await prefs.setString('user_name', myResponse.data?.name ?? "");
        // await prefs.setString('email', myResponse.data?.email ?? "");
        // await prefs.setString('electricityclass', myResponse.data?.electricityclass ?? "");

        myResponse.message = "Email sudah terdaftar";
      }
      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Mengirim Kode OTP ke Email");
    }
  }
}
