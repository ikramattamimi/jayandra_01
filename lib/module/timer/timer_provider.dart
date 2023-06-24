import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/timer/timer_repository.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<TimerModel> _timers = [];

  List<TimerModel> get timers => _timers;

  late PowerstripModel _powerstrip;

  PowerstripModel get powerstrip => _powerstrip;

  final _timerRepository = TimerRepository();

  // TimerProvider() {
  //   initializeData();
  // }

  void addTimer(TimerModel timer) {
    _timers.add(timer);
    notifyListeners();
  }

  void removeTimer(int timerId) {
    var timer = _timers.firstWhere((element) => element.timerId == timerId);
    var index = _timers.indexOf(timer);
    _timers.removeAt(index);
    notifyListeners();
  }

  set setPowerstrip(PowerstripModel powerstrip) {
    _powerstrip = powerstrip;
    notifyListeners();
  }

  Future<void> initializeData() async {
    final timerModels = await createTimerModelsFromApi();
    _timers.addAll(timerModels);
    notifyListeners();
  }

  Future<List<TimerModel>> createTimerModelsFromApi() async {
    var timerObjectResponse = MyArrayResponse();

    // Logika pemanggilan API untuk mendapatkan data timer
    // Get API data timer
    await _timerRepository.getTimer(_powerstrip.id).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> timerMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        timerObjectResponse = MyArrayResponse.fromJson(timerMapData, TimerModel.fromJson);
        timerObjectResponse.message = "Data timer berhasil dimuat";
        // return timerObjectResponse.data;
      }
    });

    // Contoh data hardcoded:
    // final timerJsonData = [
    //   {'id': 1, 'time': 60},
    //   {'id': 2, 'time': 120},
    // ];

    List<TimerModel> timerModels = [];
    for (TimerModel timerData in timerObjectResponse.data!) {
      // final id = timerData['id'];
      // final time = timerData['time'];
      // final timerModel = TimerModel(id_timer: id, time: time);
      timerData.powerstripId = _powerstrip.id;
      timerModels.add(timerData);
    }

    // _timers = timerModels;
    // notifyListeners();

    return timerModels;
  }

  static TimerProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TimerProvider>(context, listen: listen);
  }

  void changeTimerStatus(int timerId, bool isTimerOn) {
    final timer = _timers.firstWhere((timer) => timer.timerId == timerId);
    timer.changeTimerStatus(isTimerOn);
    notifyListeners();
  }
}
