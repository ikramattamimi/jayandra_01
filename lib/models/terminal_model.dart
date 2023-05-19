import 'package:jayandra_01/page/terminal/terminal_page.dart';

class Terminal {
  final int id;
  final String name;
  final List sockets;

  Terminal({this.id = 0, this.name = "", required this.sockets});
  // final int user_id;

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      name: json['name'],
      sockets: json['sockets'],
      // user_id: json['user_id'],
    );
  }
}
