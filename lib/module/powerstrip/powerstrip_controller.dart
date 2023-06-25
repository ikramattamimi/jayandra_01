import 'dart:async';
import 'dart:convert';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PowerstripController {
  /// [PowerstripRepository] untuk melakukan pemanggilan API get Powerstrip
  final PowerstripRepository pwsRepo = PowerstripRepository();

  bool isLoading = false;
  var emailValue = '';
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  String electricityClassValue = "";

  Future<MyArrayResponse?> getPowerstrip(String email, String homeName) async {
    final prefs = await SharedPreferences.getInstance();
    MyArrayResponse powerstripObjectResponse;
    // Get API data powerstrip
    http.Response response = await pwsRepo.getPowerstrip(email, homeName);
    // Jika status 200
    try {
      if (response.statusCode == 200) {
        // Setting SharedPreferences untuk data powerstrip
        prefs.setBool('isPowerstripFetched', true);

        // Parse String jsonke Map
        Map<String, dynamic> powerstripMapData = jsonDecode(response.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        powerstripObjectResponse = MyArrayResponse.fromJson(powerstripMapData, PowerstripModel.fromJson);
        powerstripObjectResponse.message = "Data powerstrip berhasil dimuat";
        return powerstripObjectResponse;
      } else {
        return MyArrayResponse(code: 1, message: "Periksa Input dan Response");
      }
    } catch (e) {
      Logger().e(e);
      return MyArrayResponse(code: 1, message: "Terjadi Masalah");
    }

    // return powerstripObjectResponse;
  }

  Future<MyResponse?> updatePowerstripName(PowerstripModel pwsModel, String homeName, String email) async {
    http.Response result;
    // responsePowerstrip = await pwsRepo.updatePowerstripName(powerstrip);
    // return null;

    try {
      result = await pwsRepo.updatePowerstripName(pwsModel, homeName, email);

      // Map<String, dynamic> myBody = jsonDecode(result.body);

      var myResponse = MyResponse();
      if (result.statusCode == 200) {
        myResponse.message = "Nama Powerstrip berhasil diupdate";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyResponse();
    }
  }
}
