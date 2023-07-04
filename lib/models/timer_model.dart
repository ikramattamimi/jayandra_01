import 'package:flutter/material.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:logger/logger.dart';

class TimerModel extends ChangeNotifier {
  final int socketNr;
  final String pwsKey;
  TimeOfDay? time;
  bool timerStatus;
  String timerName;

  TimerModel({
    this.socketNr = 0,
    this.time,
    this.timerStatus = false,
    this.pwsKey = "Pws-01",
    this.timerName = "",
  });

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    final parts = json['timer_time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);

    return TimerModel(
      pwsKey: json['pws_serial_key'],
      socketNr: json['socket_number'],
      time: time,
      timerStatus: json['timer_status'],
      timerName: json['timer_name'] ?? "",
    );
  }

  void changeTimerStatus(bool isTimerOn) {
    timerStatus = isTimerOn;
    notifyListeners();
  }

  void logger() {
    Logger().i({
      "socketNr": socketNr,
      "pwsKey": pwsKey,
      "time": time,
      "status": timerStatus,
    });
  }
}

class PowerstripTimer {
  PowerstripModel powerstrip;
  TimerModel timer;

  PowerstripTimer({required this.powerstrip, required this.timer});
}
