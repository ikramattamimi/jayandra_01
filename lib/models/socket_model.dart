class SocketModel {
  final int? socketId;
  final int? powerstripId;
  String? name;
  bool? status;

  SocketModel({this.socketId = 0, this.powerstripId = 0, this.name = "", this.status = false});

  factory SocketModel.fromJson(Map<String, dynamic> json) {
    return SocketModel(
      socketId: json['id_socket'],
      powerstripId: json['id_powerstrip'],
      name: json['name'],
      status: json['status'],
    );
  }

  void updateSocketStatus(bool isSocketOn) {
    status = isSocketOn;
  }

  void updateSocketName(String socketName) {
    name = socketName;
  }
}
