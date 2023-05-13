import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TerminalController {
  TerminalRepository _repository = TerminalRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<MyArrayResponse> getTerminal() async {
    http.Response result = await _repository.getTerminal();

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyArrayResponse<Terminal> myResponse = MyArrayResponse.fromJsonArray(myBody, Terminal.fromJson);

      // print(myResponse.data.);
      // print("${myResponse.code}");

      if (myResponse.code == 0) {
        // final prefs = await SharedPreferences.getInstance();

        // simpan token
        // await prefs.setString('token', myResponse.data?.token ?? "");
        // await prefs.setString('user_name', myResponse.data?.name ?? "");
        // await prefs.setString('email', myResponse.data?.email ?? "");
        // await prefs.setString('electricityclass', myResponse.data?.electricityclass ?? "");

        myResponse.message = "Akun berhasil dibuat";
      }
      return myResponse;
    } else {
      return MyArrayResponse(code: 1, message: "Terjadi Masalah");
    }
  }
}
