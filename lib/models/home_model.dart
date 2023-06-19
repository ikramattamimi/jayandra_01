import 'dart:ffi';

import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  String email;
  String homeName;
  String className;
  double budget;
  int userId; // nanti dihapus

  HomeModel({
    this.email = "",
    this.homeName = "",
    this.className = "",
    this.budget = 0,
    this.userId = 0,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      // email: json[''],
      // userId: json['id_user'],
      className: json['class_name'],
      homeName: json['home_name'],
      budget: double.parse(json['budget'].toString()),
    );
  }
}
