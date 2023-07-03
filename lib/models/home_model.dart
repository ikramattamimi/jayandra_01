import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  int homeId;
  String homeName;
  String className;
  double budget;

  HomeModel({
    this.homeId = 0,
    this.homeName = "",
    this.className = "",
    this.budget = 0,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      // email: json[''],
      homeId: json['id_home'],
      className: json['class_name'],
      homeName: json['home_name'],
      budget: json['budget'] != 0 ? double.parse(json['budget'].toString()) : 0,
    );
  }
}
