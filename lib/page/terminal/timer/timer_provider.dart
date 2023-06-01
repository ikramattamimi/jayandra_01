import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/timer_repository.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  List<TimerModel> _timers = [];

  List<TimerModel> get timers => _timers;

  final _timerRepository = TimerRepository();

    TimerProvider() {
    initializeData();
  }

  void addTimer(TimerModel timer) {
    _timers.add(timer);
    notifyListeners();
  }

  void removeTimer(int index) {
    _timers.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeData() async {
    final timerModels = await createTimerModelsFromApi();
    _timers = timerModels;
    notifyListeners();
  }

  Future<List<TimerModel>> createTimerModelsFromApi() async {
    var timerObjectResponse = MyArrayResponse();

    // Logika pemanggilan API untuk mendapatkan data timer
    // Get API data timer
    await _timerRepository.getTimer(1).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> timerMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Terminal
        timerObjectResponse = MyArrayResponse.fromJson(timerMapData, TimerModel.fromJson);
        timerObjectResponse.message = "Data terminal berhasil dimuat";
        // return timerObjectResponse.data;
      } 
      // else {
      //   return MyArrayResponse(code: 1, message: "Terjadi Masalah");
      // }
    });

    // Contoh data hardcoded:
    // final timerJsonData = [
    //   {'id': 1, 'time': 60},
    //   {'id': 2, 'time': 120},
    // ];

    List<TimerModel> timerModels = [];
    for (var timerData in timerObjectResponse.data!) {
      // final id = timerData['id'];
      // final time = timerData['time'];
      // final timerModel = TimerModel(id_timer: id, time: time);
      timerModels.add(timerData);
    }

    // _timers = timerModels;
    // notifyListeners();

    return timerModels;
  }

  static TimerProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TimerProvider>(context, listen: listen);
  }
}
