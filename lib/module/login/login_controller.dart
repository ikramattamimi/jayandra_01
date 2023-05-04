import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  LoginRepository _repository = LoginRepository();

  bool isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<MyResponse> login() async {
    http.Response result = await _repository.login(emailController.text, passwordController.text);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

      // print(myBody);
      // print("${myResponse.code}");

      if (myResponse.code == 0) {
        final prefs = await SharedPreferences.getInstance();

        // simpan token
        await prefs.setString('token', myResponse.data?.token ?? "");
      }

      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Username atau Password Salah");
    }
  }
}
