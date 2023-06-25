import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/module/powerstrip/powerstrip_repository.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketController {
  /// [PowerstripRepository] untuk melakukan pemanggilan API get Powerstrip
  final PowerstripRepository pwsRepo = PowerstripRepository();
  final TextEditingController socketNameController = TextEditingController();

  bool isLoading = false;

  Future<MyResponse?> setSocketStatus(SocketModel socket) async {
    http.Response responseSocket;
    responseSocket = await pwsRepo.setSocketStatus(socket.socketNr, socket.pwsKey, socket.status);

    // Parse String jsonke Map
    Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);

    MyResponse updateSocketResponse = MyResponse.fromJson(socketMapData, SocketModel.fromJson);

    return updateSocketResponse;
  }

  Future<MyResponse> updateSocketName(SocketModel socket) async {
    http.Response responseSocket;
    var updateSocketResponse = MyResponse();
    try {
      // Memproses API
      responseSocket = await Future.any([
        pwsRepo.updateSocketName(socket),
        Future.delayed(
          const Duration(seconds: 10),
          () => throw TimeoutException('API call took too long'),
        ),
      ]);

      // Parse String jsonke Map
      Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);
      updateSocketResponse = MyResponse.fromJson(socketMapData, SocketModel.fromJson);
      updateSocketResponse.message = "Nama socket berhasil diganti";
      return updateSocketResponse;
    } catch (err) {
      Logger(printer: PrettyPrinter()).e(err);
      return updateSocketResponse;
    }
  }

  Future<PowerstripResponse?> changeAllSocketStatus(String pwsKey, bool status) async {
    final prefs = await SharedPreferences.getInstance();
    PowerstripResponse? powerstripObjectResponse;
    // Get API data powerstrip
    await pwsRepo.changeAllSocketStatus(pwsKey, status).then((value) async {
      prefs.remove('powerstrip');
      // powerstripObjectResponse = await getPowerstrip();
    });
    return powerstripObjectResponse;
  }
}
