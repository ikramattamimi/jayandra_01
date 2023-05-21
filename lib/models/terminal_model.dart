import 'package:jayandra_01/models/socket_model.dart';

class Terminal {
  final int id;
  final String name;
  final List<Socket> sockets;
  bool isTerminalActive;
  int totalActiveSocket;

  Terminal({
    this.id = 0,                             
    this.name = "",
    required this.sockets,
    this.isTerminalActive = false,
    this.totalActiveSocket = 0,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    var isTerminalActive = false;
    var totalActiveSoccket = 0;
    List<Socket> sockets = [];
    for (var socket in json['sockets']) {
      sockets.add(Socket.fromJson(socket));
      if (socket['status'] == true) {
        totalActiveSoccket++;
        isTerminalActive = true;
      }
    }
    return Terminal(
      id: json['id'],
      name: json['name'],
      sockets: sockets,
      isTerminalActive: isTerminalActive,
      totalActiveSocket: totalActiveSoccket,
      // user_id: json['user_id'],
    );
  }
}
