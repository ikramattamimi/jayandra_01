class Timer {
  final int? id_timer;
  final int? id_socket;
  final String? time;
  final bool status;

  Timer({this.id_timer = 0, this.id_socket = 0, this.time = "", this.status = false});

  factory Timer.fromJson(Map<String, dynamic> json) {
    return Timer(
      id_timer: json['id_timer'],
      id_socket: json['id_socket'],
      time: json['time'],
      status: json['status'],
    );
  }
}
