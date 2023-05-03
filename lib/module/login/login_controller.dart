import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'login_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  LoginRepository _repository = LoginRepository();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<MyResponse> login() async {
    http.Response result = await _repository.login(emailController.text, passwordController.text);
    print(result.statusCode);

    Map<String, dynamic> myBody = jsonDecode(result.body);
    MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

    print("${myResponse.code}");

    return myResponse;
  }
}
