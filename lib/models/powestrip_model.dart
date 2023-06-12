import 'package:flutter/material.dart';
import 'package:jayandra_01/models/socket_model.dart';

class PowerstripModel extends ChangeNotifier {
  final int id;
  String name;
  final List<SocketModel>? sockets;
  bool isPowerstripActive;
  int totalActiveSocket;

  PowerstripModel({
    this.id = 0,
    this.name = "",
    this.sockets,
    this.isPowerstripActive = false,
    this.totalActiveSocket = 0,
  });

  factory PowerstripModel.fromJson(Map<String, dynamic> json) {
    var isPowerstripActive = false;
    var totalActiveSoccket = 0;
    List<SocketModel> sockets = [];
    for (var socket in json['sockets']) {
      sockets.add(SocketModel.fromJson(socket));
      if (socket['status'] == true) {
        totalActiveSoccket++;
        isPowerstripActive = true;
      }
    }
    return PowerstripModel(
      id: json['id'],
      name: json['name'],
      sockets: sockets,
      isPowerstripActive: isPowerstripActive,
      totalActiveSocket: totalActiveSoccket,
      // user_id: json['user_id'],
    );
  }

  void updateAllSocketStatus(bool isPowerstripOn) {
    setPowerstripStatus(isPowerstripOn);
    isPowerstripOn ? totalActiveSocket = 4 : totalActiveSocket = 0;
    notifyListeners();
  }

  void updateOneSocketStatus(int socketId, bool isSocketOn) {
    SocketModel socket = sockets!.firstWhere((element) => element.socketId == socketId);
    socket.updateSocketStatus(isSocketOn);
    setPowerstripStatusWhenSocketChange();
    setTotalActiveSocket();
    notifyListeners();
  }

  void setPowerstripStatus(bool isPowerstripOn) {
    isPowerstripActive = isPowerstripOn;
    notifyListeners();
  }

  void setPowerstripStatusWhenSocketChange() {
    for (var socket in sockets!) {
      if (socket.status == true) {
        isPowerstripActive = true;
        break;
      } else {
        isPowerstripActive = false;
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

  void setPowerstripName(String powerstripName) {
    name = powerstripName;
  }
}
