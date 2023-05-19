import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyState with ChangeNotifier {
  String myVariable = '';

  void setMyVariable(String value) {
    myVariable = value;
    notifyListeners();
  }
}