import 'package:flutter/material.dart';
import 'package:jayandra_01/models/socket_model.dart';

class TerminalModel extends ChangeNotifier {
  final int id;
  final String name;
  final List<SocketModel>? sockets;
  bool isTerminalActive;
  int totalActiveSocket;

  TerminalModel({
    this.id = 0,
    this.name = "",
    this.sockets,
    this.isTerminalActive = false,
    this.totalActiveSocket = 0,
  });

  factory TerminalModel.fromJson(Map<String, dynamic> json) {
    var isTerminalActive = false;
    var totalActiveSoccket = 0;
    List<SocketModel> sockets = [];
    for (var socket in json['sockets']) {
      sockets.add(SocketModel.fromJson(socket));
      if (socket['status'] == true) {
        totalActiveSoccket++;
        isTerminalActive = true;
      }
    }
    return TerminalModel(
      id: json['id'],
      name: json['name'],
      sockets: sockets,
      isTerminalActive: isTerminalActive,
      totalActiveSocket: totalActiveSoccket,
      // user_id: json['user_id'],
    );
  }

  void updateAllSocketStatus(bool isTerminalOn) {
    setTerminalStatus(isTerminalOn);
    isTerminalOn ? totalActiveSocket = 4 : totalActiveSocket = 0;
    notifyListeners();
  }

  void updateOneSocketStatus(int socketId, bool isSocketOn) {
    SocketModel socket = sockets!.firstWhere((element) => element.socketId == socketId);
    socket.updateSocketStatus(isSocketOn);
    setTerminalStatusWhenSocketChange();
    setTotalActiveSocket();
    notifyListeners();
  }

  void setTerminalStatus(bool isTerminalOn) {
    isTerminalActive = isTerminalOn;
    notifyListeners();
  }

  void setTerminalStatusWhenSocketChange() {
    for (var socket in sockets!) {
      if (socket.status == true) {
        isTerminalActive = true;
        break;
      } else {
        isTerminalActive = false;
      }
      // notifyListeners();
    }
  }

  void setTotalActiveSocket() {
    int total = 0;
    for (var socket in sockets!) {
      if (socket.status == true) {
        total++;
      }
    }
    totalActiveSocket = total;
  }
}
