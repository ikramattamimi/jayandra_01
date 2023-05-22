import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TerminalController {
  /// [TerminalRepository] untuk melakukan pemanggilan API get Terminal
  TerminalRepository _terminalRepositroy = TerminalRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<TerminalResponse?> getTerminal() async {
    // print('get terminal dipanggil');
    final prefs = await SharedPreferences.getInstance();

    // Data terminal berupa string json dari response API
    // yang disimpan di SharedPreferences
    String? terminalData = prefs.getString('terminal');

    http.Response response;

    // Jika data terminal belum disetting di SharedPreferences
    if (terminalData == null) {
      // Get API data terminal
      response = await _terminalRepositroy.getTerminal();

      // Jika status 200
      if (response.statusCode == 200) {
        // Setting SharedPreferences untuk data terminal
        prefs.setString('terminal', response.body);
        terminalData = prefs.getString('terminal');
        // print(terminalData);
      } else {
        return TerminalResponse(code: 1, message: "Terjadi Masalah");
      }
    }

    // Parse String jsonke Map
    Map<String, dynamic> terminalMapData = jsonDecode(terminalData!);

    // Response dengan response.data berupa List dari objek Terminal
    TerminalResponse terminalObjectResponse = TerminalResponse.fromJsonArray(terminalMapData, Terminal.fromJson);
    terminalObjectResponse.message = "Data terminal berhasil dimuat";

    return terminalObjectResponse;
  }

  Future<MyResponse?> updateSocket(Socket socket) async {
    http.Response responseSocket;
    responseSocket = await _terminalRepositroy.updateSocket(socket);

    // Parse String jsonke Map
    Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);

    MyResponse updateSocketResponse = MyResponse.fromJson(socketMapData, Socket.fromJson);
    // print(updateSocketResponse.data.status);
    Socket updatedSocket = updateSocketResponse.data;
    /////

    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    prefs.remove('terminal');
    getTerminal();

    return updateSocketResponse;
  }

  Future<TerminalResponse?> changeAllSocketStatus(int id_terminal, bool status) async {
    // print('get terminal dipanggil');
    final prefs = await SharedPreferences.getInstance();
    TerminalResponse? _terminalObjectResponse;

    print('update all socket');

    // Get API data terminal
    await _terminalRepositroy.changeAllSocketStatus(id_terminal, status).then((value) async {
      prefs.remove('terminal');
      _terminalObjectResponse = await getTerminal();
    });
    return _terminalObjectResponse;
  }
}
