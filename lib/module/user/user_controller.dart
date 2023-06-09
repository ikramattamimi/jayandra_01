import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'user_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserController {
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

  Future<MyResponse> changePassword(String email, String password) async {
    http.Response result = await _repository.changePassword(email, password);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<UserModel> myResponse = MyResponse.fromJson(myBody, UserModel.fromJson);
      myResponse.message = "Ubah Password Berhasil Berhasil";
      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Terjadi Masalah");
    }
  }

  Future<MyResponse> changeName(String email, String name) async {
    http.Response result = await _repository.changeName(email, name);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<UserModel> myResponse = MyResponse.fromJson(myBody, UserModel.fromJson);
      myResponse.message = "Ubah Nama Berhasil";
      return myResponse;
    } else {
      return MyResponse(code: 1, message: "Terjadi Masalah");
    }
  }
}
