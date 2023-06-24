import 'dart:convert';

import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_repository.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeController {
  final HomeRepository homeRepo = HomeRepository();

  bool isLoading = false;
  var homeNameController = TextEditingController();
  var elClassController = TextEditingController();
  var budgetingController = TextEditingController();

  Future<MyResponse> addHome(BuildContext context) async {
    var user = Provider.of<UserModel>(context, listen: false);
    Logger().i(user.userId);

    try {
      http.Response result = await homeRepo.addHome(
        homeNameController.text,
        elClassController.text,
        user.email,
        budgetingController.text,
      );

      Map<String, dynamic> myBody = jsonDecode(result.body);

      MyResponse<HomeModel> myResponse = MyResponse.fromJson(myBody, HomeModel.fromJson);
      if (result.statusCode == 200) {
        myResponse.message = "Home Berhasil Ditambahkan";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyResponse();
    }
  }

  Future<MyArrayResponse> getHome(int userId) async {
    http.Response result = await homeRepo.getHome(userId.toString());
    Map<String, dynamic> myBody = jsonDecode(result.body);
    var myResponse = MyArrayResponse.fromJson(myBody, HomeModel.fromJson);
    return myResponse;
  }
}
