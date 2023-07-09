import 'package:flutter/material.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:logger/logger.dart';

class PowerstripModel extends ChangeNotifier {
  String pwsKey;
  String pwsName;
  int homeId;
  final List<SocketModel> sockets;
  bool isPowerstripActive;
  int totalActiveSocket;

  PowerstripModel({
    this.pwsKey = "",
    this.pwsName = "Powerstrip",
    this.homeId = 0,
    required this.sockets,
    this.isPowerstripActive = false,
    this.totalActiveSocket = 0,
  });

  factory PowerstripModel.fromJson(Map<String, dynamic> json) {
    var isPowerstripActive = false;
    var totalActiveSoccket = 0;
    List<SocketModel> sockets = [];
    for (var socket in json['sockets']) {
      sockets.add(SocketModel.fromJson(socket));
      if (socket['socket_status'] == true) {
        totalActiveSoccket++;
        isPowerstripActive = true;
      }
    }
    return PowerstripModel(
      pwsKey: json['pws_serial_key'],
      pwsName: json['pws_name'],
      homeId: json['id_home'],
      sockets: sockets,
      isPowerstripActive: isPowerstripActive,
      totalActiveSocket: totalActiveSoccket,
      // user_id: json['user_id'],
    );
  }

  void logger() {
    Logger().i({
      'name': pwsName,
      'home_id': homeId,
      'sockets': sockets,
      'isPowerstripActive': isPowerstripActive,
      'totalActiveSocket': totalActiveSocket,
    });
  }

  void updateAllSocketStatus(bool isPowerstripOn) {
    setPowerstripStatus(isPowerstripOn);
    isPowerstripOn ? totalActiveSocket = 4 : totalActiveSocket = 0;
    notifyListeners();
  }

  void updateOneSocketStatus(int socketId, bool isSocketOn) {
    SocketModel socket = sockets.firstWhere((element) => element.socketNr == socketId);
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
    for (var socket in sockets) {
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
    for (var socket in sockets) {
      if (socket.status == true) {
        total++;
      }
    }
    totalActiveSocket = total;
  }

  void setPowerstripName(String powerstripName) {
    pwsName = powerstripName;
  }
}
