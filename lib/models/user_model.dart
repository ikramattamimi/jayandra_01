import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserModel extends ChangeNotifier {
  int userId;
  String name;
  String email;
  String? password;

  UserModel({
    this.userId = 16,
    this.name = "",
    this.email = "",
    this.password = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // userId: json['id_user'],
      name: json['name'],
      email: json['email'],
      password: (json['password'] != null) ? json['password'] : "",
    );
  }

  void updateUser({required int userId, required String name, required String email, String? password}) {
    this.userId = userId;
    this.name = name;
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  void updateElectricityClass(String elecClass) {
    // electricityclass = elecClass;
    notifyListeners();
  }

  void setUserName(String userName) {
    name = userName;
    notifyListeners();
  }

  void logger() {
    Logger().i({
      "userId": userId,
      "name": name,
      "email": email,
      "password": password,
    });
  }
}
