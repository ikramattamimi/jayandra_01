import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/register/cek_email_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CekEmailController {
  final CekEmailRepository _repository = CekEmailRepository();

  bool isLoading = false;
  var emailController = TextEditingController();

  Future<MyResponse> cekEmail() async {
    http.Response result = await _repository.cekEmail(emailController.text);

    if (result.statusCode == 200) {
      return MyResponse(code: 0, message: "Email Sudah Terdaftar");
    } else {
      return MyResponse(code: 1, message: "Mengirim Kode OTP ke Email");
    }
  }
}
