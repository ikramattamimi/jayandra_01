import 'package:flutter/material.dart';
import 'package:jayandra_01/models/day_model.dart';

class ScheduleModel {
  ScheduleModel({
    this.id_schedule = 0,
    this.id_socket = 0,
    this.time,
    this.status = false,
    required this.note,
    required this.days,
  });

  final int? id_schedule;
  final int? id_socket;
  final TimeOfDay? time;
  final bool status;
  final String note;
  final List<DayModel> days;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final parts = json['time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);
    return ScheduleModel(
      id_schedule: json['id_schedule'],
      id_socket: json['id_socket'],
      time: time,
      status: json['status'],
      days: json['days'],
      note: '',
    );
  }
}
