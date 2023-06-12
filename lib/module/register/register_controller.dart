import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/register/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  final RegisterRepository _repository = RegisterRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<MyResponse> register() async {
    UserModel user = UserModel(
      name: nameController.text,
      password: passwordController.text,
      email: emailValue,
      electricityclass: electricityClassValue,
    );
    http.Response result = await _repository.register(user);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<UserModel> myResponse = MyResponse.fromJson(myBody, UserModel.fromJson);

      if (myResponse.code == 0) {
        myResponse.message = "Akun berhasil dibuat";
      }
      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Terjadi Masalah");
    }
  }
}
