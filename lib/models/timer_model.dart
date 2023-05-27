import 'package:flutter/material.dart';

class TimerModel {
  final int? id_timer;
  final int? id_socket;
  final TimeOfDay? time;
  final bool status;

  TimerModel({this.id_timer = 0, this.id_socket = 0, this.time, this.status = false});

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    final parts = json['time'].split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);
    
    return TimerModel(
      id_timer: json['id_timer'],
      id_socket: json['id_socket'],
      time: time,
      status: json['status'],
    );
  }
}
