import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TerminalController {
  TerminalRepository _repository = TerminalRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<String?> getTerminal() async {
    http.Response result = await _repository.getTerminal();

    if (result.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      String? terminalData = prefs.getString('terminal');

      MyArrayResponse<Terminal> myResponse = MyArrayResponse();
      if (terminalData == null) {
        await prefs.setString('terminal', result.body);
        terminalData = prefs.getString('terminal').toString();

        // Map<String, dynamic> myBody = jsonDecode(prefs.getString('terminal').toString());

        // myResponse = MyArrayResponse.fromJsonArray(myBody, Terminal.fromJson);

        // print(myResponse.data.);
        // print("${myResponse.code}");

        if (myResponse.code == 0) {
          // final prefs = await SharedPreferences.getInstance();

          // simpan token
          // await prefs.setString('token', myResponse.data?.token ?? "");
          // await prefs.setString('user_name', myResponse.data?.name ?? "");
          // await prefs.setString('email', myResponse.data?.email ?? "");
          // await prefs.setString('electricityclass', myResponse.data?.electricityclass ?? "");

          // print(myBody);

          myResponse.message = "Data terminal berhasil dimuat";
        }
      }
      // print(terminalData);
      return terminalData;
    } else {
      // return MyArrayResponse(code: 1, message: "Terjadi Masalah");
    }
  }
}
