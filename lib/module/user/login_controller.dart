import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'user_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final UserRepository _repository = UserRepository();

  bool isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<MyResponse> login() async {
    http.Response result = await _repository.login(emailController.text, passwordController.text);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<UserModel> myResponse = MyResponse.fromJson(myBody, UserModel.fromJson);
      myResponse.message = "Login Berhasil";
      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Username atau Password Salah");
    }
  }
}
