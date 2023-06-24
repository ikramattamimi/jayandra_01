import 'package:flutter/material.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:logger/logger.dart';

class TimerModel extends ChangeNotifier {
  final int timerId;
  final int? socketId;
  int powerstripId;
  final TimeOfDay? time;
  bool status;

  TimerModel({this.timerId = 0, this.socketId = 0, this.time, this.status = false, this.powerstripId = 1});

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    final parts = json['time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);

    return TimerModel(
      timerId: json['id_timer'],
      socketId: json['id_socket'],
      time: time,
      status: json['status'],
    );
  }

  void changeTimerStatus(bool isTimerOn) {
    status = isTimerOn;
    notifyListeners();
  }

  void logger() {
    Logger().i({
      "timerId": timerId,
      "socketId": socketId,
      "powerstripId": powerstripId,
      "time": time,
      "status": status,
    });
  }
}

class PowerstripTimer {
  PowerstripModel powerstrip;
  TimerModel timer;

  PowerstripTimer({required this.powerstrip, required this.timer});
}
