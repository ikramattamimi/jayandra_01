import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PowerstripController {
  /// [PowerstripRepository] untuk melakukan pemanggilan API get Powerstrip
  final PowerstripRepository _powerstripRepositroy = PowerstripRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<PowerstripResponse?> getPowerstrip(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    PowerstripResponse powerstripObjectResponse;
    // Get API data powerstrip
    http.Response response = await _powerstripRepositroy.getPowerstrip(userId);
    // Jika status 200
    if (response.statusCode == 200) {
      // Setting SharedPreferences untuk data powerstrip
      prefs.setBool('isPowerstripFetched', true);

      // Parse String jsonke Map
      Map<String, dynamic> powerstripMapData = jsonDecode(response.body);

      // Response dengan response.data berupa List dari objek Powerstrip
      powerstripObjectResponse = PowerstripResponse.fromJsonArray(powerstripMapData, PowerstripModel.fromJson);
      powerstripObjectResponse.message = "Data powerstrip berhasil dimuat";
      return powerstripObjectResponse;
    } else {
      return PowerstripResponse(code: 1, message: "Terjadi Masalah");
    }

    // return powerstripObjectResponse;
  }

  Future<MyResponse?> setSocketStatus(SocketModel socket) async {
    http.Response responseSocket;
    responseSocket = await _powerstripRepositroy.setSocketStatus(socket.socketId!, socket.powerstripId!, socket.status!);

    // Parse String jsonke Map
    Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);

    MyResponse updateSocketResponse = MyResponse.fromJson(socketMapData, SocketModel.fromJson);

    return updateSocketResponse;
  }

  Future<MyResponse?> updateSocketName(SocketModel socket) async {
    http.Response responseSocket;
    responseSocket = await _powerstripRepositroy.updateSocketName(socket);

    // Parse String jsonke Map
    Map<String, dynamic> socketMapData = jsonDecode(responseSocket.body);
    MyResponse updateSocketResponse = MyResponse.fromJson(socketMapData, SocketModel.fromJson);
    return updateSocketResponse;
  }

  Future<MyResponse?> updatePowerstripName(PowerstripModel powerstrip) async {
    http.Response responsePowerstrip;
    responsePowerstrip = await _powerstripRepositroy.updatePowerstripName(powerstrip);

    // Parse String jsonke Map
    Map<String, dynamic> powerstripMapData = jsonDecode(responsePowerstrip.body);
    MyResponse updatePowerstripResponse = MyResponse.fromJson(powerstripMapData, PowerstripModel.fromJson);
    return updatePowerstripResponse;
  }

  Future<PowerstripResponse?> changeAllSocketStatus(int idPowerstrip, bool status) async {
    // print('get powerstrip dipanggil');
    final prefs = await SharedPreferences.getInstance();
    PowerstripResponse? powerstripObjectResponse;

    print('update all socket');

    // Get API data powerstrip
    await _powerstripRepositroy.changeAllSocketStatus(idPowerstrip, status).then((value) async {
      prefs.remove('powerstrip');
      // powerstripObjectResponse = await getPowerstrip();
    });
    return powerstripObjectResponse;
  }
}
