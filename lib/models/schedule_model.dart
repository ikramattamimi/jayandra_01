import 'package:flutter/material.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/powestrip_model.dart';

class ScheduleModel extends ChangeNotifier {
  ScheduleModel({
    this.scheduleId = 0,
    this.sockeId = 0,
    this.time,
    this.status = false,
    required this.scheduleStatus,
    required this.note,
    required this.days,
  });

  final int? scheduleId;
  final int? sockeId;
  final TimeOfDay? time;
  bool status;
  bool scheduleStatus;
  final String note;
  final List<DayModel> days;
  int? powerstripId;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final parts = json['time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);

    List<DayModel> days = DaysIndonesia.getDay();
    // print(json[time]);
    for (var element in json['Scheduling_day ']) {
      days.where((day) => day.id == element['id_days'] - 1).first.isSelected = true;
    }

    return ScheduleModel(
      scheduleId: json['id_scheduling'],
      sockeId: json['id_socket'],
      time: time,
      status: json['status'],
      scheduleStatus: json['statusonschedule'],
      days: days,
      note: json['note'],
    );
  }

  void changeScheduleStatus(bool isScheduleOn) {
    status = isScheduleOn;
    notifyListeners();
  }
}

class PowerstripSchedule {
  PowerstripModel powerstrip;
  ScheduleModel schedule;

  PowerstripSchedule({required this.powerstrip, required this.schedule});
}
