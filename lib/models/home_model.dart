import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  String email;
  String homeName;
  String className;
  double budget;

  HomeModel({
    this.email = "",
    this.homeName = "",
    this.className = "",
    this.budget = 0,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
  return HomeModel(
      // email: json[''],
      // userId: json['id_user'],
      className: json['class_name'],
      homeName: json['home_name'],
      budget: json['budget'] != 0 ? double.parse(json['budget'].toString()) : 0,
    );
  }
}
