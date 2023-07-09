import 'package:flutter/material.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';

class ScheduleModel extends ChangeNotifier {
  ScheduleModel({
    this.socketNr = 0,
    this.time,
    this.socketStatus = false,
    required this.scheduleStatus,
    this.scheduleName = "",
    required this.days,
    this.pwsKey = "",
  });

  final int socketNr;
  TimeOfDay? time;
  bool socketStatus;
  bool scheduleStatus;
  String scheduleName;
  List<String> days;
  String pwsKey;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final parts = json['schedule_time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);
    var selectedDay = <String>[];
    var daysIndo = DaysIndonesia.getDay();

    for (var element in json['Schedule_day ']) {
      daysIndo.where((day) => day.name == element['id_day']).first.isSelected = true;
    }

    for (var day in daysIndo) {
      if (day.isSelected) {
        selectedDay.add(day.name);
      }
    }

    return ScheduleModel(
      socketNr: json['socket_number'],
      time: time,
      socketStatus: json['schedule_socket_status'],
      scheduleStatus: json['schedule_status'],
      days: selectedDay,
      scheduleName: json['schedule_name'] ?? "",
    );
  }

  void changeScheduleStatus(bool isScheduleOn) {
    scheduleStatus = isScheduleOn;
    notifyListeners();
  }
}

class PowerstripSchedule {
  PowerstripModel powerstrip;
  ScheduleModel schedule;

  PowerstripSchedule({required this.powerstrip, required this.schedule});
}
