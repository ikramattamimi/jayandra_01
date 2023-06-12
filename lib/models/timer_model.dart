import 'package:flutter/material.dart';
import 'package:jayandra_01/models/terminal_model.dart';

class TimerModel extends ChangeNotifier {
  final int? timerId;
  final int? socketId;
  int? terminalId;
  final TimeOfDay? time;
  bool status;

  TimerModel({this.timerId = 0, this.socketId = 0, this.time, this.status = false, this.terminalId});

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
}

class TerminalTimer {
  TerminalModel terminal;
  TimerModel timer;

  TerminalTimer({required this.terminal, required this.timer});
}
