import 'package:flutter/material.dart';

class SocketModel {
  final int? id_socket;
  final int? id_terminal;
  final String? name;
  bool? status;

  SocketModel({this.id_socket = 0, this.id_terminal = 0, this.name = "", this.status = false});

  factory SocketModel.fromJson(Map<String, dynamic> json) {
    return SocketModel(
      id_socket: json['id_socket'],
      id_terminal: json['id_terminal'],
      name: json['name'],
      status: json['status'],
    );
  }

  void updateSocketStatus(bool isSocketOn) {
    status = isSocketOn;
  }
}
