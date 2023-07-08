import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/register/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RegisterController {
  final RegisterRepository repository = RegisterRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var repeatPasswordController = TextEditingController();

  Future<MyResponse> register() async {
    UserModel user = UserModel(
      name: nameController.text,
      password: passwordController.text,
      email: emailValue,
    );
    http.Response result = await repository.register(user);

    if (result.statusCode == 201) {
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

  Future<MyResponse> sendOTP(String email) async {
    var powerstripObjectResponse = MyResponse();
    // Get API data powerstrip
    http.Response response = await repository.sendOTP(email);
    // Jika status 200
    try {
      if (response.statusCode == 200) {
        powerstripObjectResponse.message = "Mengirimkan kode OTP ke Email";
        return powerstripObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    } catch (e) {
      Logger().e(e);
      return MyResponse(code: 1, message: "Terjadi Masalah");
    }
  }

  Future<MyResponse> verifyOTP(String email, String otp) async {
    var powerstripObjectResponse = MyResponse();
    // Get API data powerstrip
    http.Response response = await repository.verifyOTP(email, otp);
    // Jika status 200
    try {
      if (response.statusCode == 200) {
        powerstripObjectResponse.message = "Verifikasi OTP berhasil";
        return powerstripObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Kode OTP salah / Sudah tidak berlaku");
      }
    } catch (e) {
      Logger().e(e);
      return MyResponse(code: 1, message: "Terjadi Masalah");
    }
  }
}
