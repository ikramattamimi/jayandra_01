class SocketModel {
  final int socketNr;
  String name;
  String pwsKey;
  bool status;

  SocketModel({
    this.pwsKey = "",
    this.socketNr = 0,
    this.name = "",
    this.status = false,
  });

  factory SocketModel.fromJson(Map<String, dynamic> json) {
    return SocketModel(
      pwsKey: json['pws_serial_key'],
      socketNr: json['socket_number'],
      name: json['socket_name'],
      status: json['socket_status'],
    );
  }

  void updateSocketStatus(bool isSocketOn) {
    status = isSocketOn;
  }

  void updateSocketName(String socketName) {
    name = socketName;
  }
}
