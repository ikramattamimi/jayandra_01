class Socket {
  final int? id_socket;
  final int? id_terminal;
  final String? name;
  final bool? status;

  Socket({this.id_socket = 0, this.id_terminal = 0, this.name = "", this.status = false});

  factory Socket.fromJson(Map<String, dynamic> json) {
    return Socket(
      id_socket: json['id_socket'],
      id_terminal: json['id_terminal'],
      name: json['name'],
      status: json['status'],
    );
  }
}
