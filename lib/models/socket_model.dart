class SocketModel {
  final int? socketId;
  final int? terminalId;
  final String? name;
  bool? status;

  SocketModel({this.socketId = 0, this.terminalId = 0, this.name = "", this.status = false});

  factory SocketModel.fromJson(Map<String, dynamic> json) {
    return SocketModel(
      socketId: json['id_socket'],
      terminalId: json['id_terminal'],
      name: json['name'],
      status: json['status'],
    );
  }

  void updateSocketStatus(bool isSocketOn) {
    status = isSocketOn;
  }
}
