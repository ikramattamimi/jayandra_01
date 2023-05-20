import 'package:jayandra_01/models/socket_model.dart';

class Terminal {
  final int id;
  final String name;
  final List<Socket> sockets;

  Terminal({this.id = 0, this.name = "", required this.sockets});
  // final int user_id;

  factory Terminal.fromJson(Map<String, dynamic> json) {
    List<Socket> sockets = [];
    for (var socket in json['sockets']) {
      sockets.add(Socket.fromJson(socket));
    }
    return Terminal(
      id: json['id'],
      name: json['name'],
      sockets: sockets,
      // user_id: json['user_id'],
    );
  }
}
