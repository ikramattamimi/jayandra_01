import 'package:flutter/material.dart';

class MyState with ChangeNotifier {
  String myVariable = '';

  void setMyVariable(String value) {
    myVariable = value;
    notifyListeners();
  }
}