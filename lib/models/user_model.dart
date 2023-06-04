import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  int id;
  String name;
  String email;
  String password;
  String electricityclass;
  String token;

  UserModel({this.id = 0, this.name = "", this.email = "", this.password = "", this.electricityclass = "", this.token = ""});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: (json['password'] != null) ? json['password'] : "",
      electricityclass: (json['electricityclass'] != null) ? json['electricityclass'] : "",
      token: json['token'],
    );
  }

  void updateUser(UserModel user) {
    id = user.id;
    name = user.name;
    email = user.email;
    password = user.password;
    electricityclass = user.electricityclass;
    token = user.token;
    notifyListeners();
  }

  void updateElectricityClass(String elecClass) {
    electricityclass = elecClass;
    notifyListeners();
  }

  void setUserName(String userName) {
    name = userName;
    notifyListeners();
  }
}
