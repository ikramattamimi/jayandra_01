import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TerminalController {
  /// [TerminalRepository] untuk melakukan pemanggilan API get Terminal
  final TerminalRepository _terminalRepositroy = TerminalRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<TerminalResponse?> getTerminal(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    TerminalResponse terminalObjectResponse;
    // Get API data terminal
    http.Response response = await _terminalRepositroy.getTerminal(userId);
    // Jika status 200
    if (response.statusCode == 200) {
      // Setting SharedPreferences untuk data terminal
      prefs.setBool('isTerminalFetched', true);

      // Parse String jsonke Map
      Map<String, dynamic> terminalMapData = jsonDecode(response.body);

      // Response dengan response.data berupa List dari objek Terminal
      terminalObjectResponse = TerminalResponse.fromJsonArray(terminalMapData, TerminalModel.fromJson);
      terminalObjectResponse.message = "Data terminal berhasil dimuat";
      print(terminalObjectResponse.data);
      return terminalObjectResponse;
    } else {
      return TerminalResponse(code: 1, message: "Terjadi Masalah");
    }

    // return terminalObjectResponse;
  }

  Future<MyResponse?> updateSocket(SocketModel socket) async {
    http.Response responseSocket;
    responseSocket = await _terminalRepositroy.updateSocket(socket);

    // Parse String jsonke Map
    Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);

    MyResponse updateSocketResponse = MyResponse.fromJson(socketMapData, SocketModel.fromJson);
    // print(updateSocketResponse.data.status);
    SocketModel updatedSocket = updateSocketResponse.data;
    /////

    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    prefs.remove('terminal');
    // getTerminal();

    return updateSocketResponse;
  }

  Future<TerminalResponse?> changeAllSocketStatus(int idTerminal, bool status) async {
    // print('get terminal dipanggil');
    final prefs = await SharedPreferences.getInstance();
    TerminalResponse? terminalObjectResponse;

    print('update all socket');

    // Get API data terminal
    await _terminalRepositroy.changeAllSocketStatus(idTerminal, status).then((value) async {
      prefs.remove('terminal');
      // terminalObjectResponse = await getTerminal();
    });
    return terminalObjectResponse;
  }
}
