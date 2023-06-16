import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  int userId;
  String name;
  String email;
  String password;

  UserModel({
    this.userId = 0,
    this.name = "",
    this.email = "",
    this.password = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id_user'],
      name: json['name'],
      email: json['email'],
      password: (json['password'] != null) ? json['password'] : "",
    );
  }

  void updateUser(UserModel user) {
    userId = user.userId;
    name = user.name;
    email = user.email;
    password = user.password;
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
}
