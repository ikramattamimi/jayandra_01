import 'package:flutter/material.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';

class ScheduleModel extends ChangeNotifier {
  ScheduleModel({
    this.socketNr = 0,
    this.time,
    this.socketStatus = false,
    required this.scheduleStatus,
    required this.note,
    required this.days,
    this.pwsKey = "Pws-01"
  });

  final int? socketNr;
  final TimeOfDay? time;
  bool socketStatus;
  bool scheduleStatus;
  final String note;
  final List<DayModel> days;
  String pwsKey;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final parts = json['time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);

    List<DayModel> days = DaysIndonesia.getDay();
    for (var element in json['Scheduling_day ']) {
      days.where((day) => day.id == element['id_days'] - 1).first.isSelected = true;
    }

    return ScheduleModel(
      socketNr: json['id_socket'],
      time: time,
      socketStatus: json['status'],
      scheduleStatus: json['statusonschedule'],
      days: days,
      note: json['note'],
    );
  }

  void changeScheduleStatus(bool isScheduleOn) {
    socketStatus = isScheduleOn;
    notifyListeners();
  }
}

class PowerstripSchedule {
  PowerstripModel powerstrip;
  ScheduleModel schedule;

  PowerstripSchedule({required this.powerstrip, required this.schedule});
}
