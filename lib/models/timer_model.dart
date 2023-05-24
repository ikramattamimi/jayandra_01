class TimerModel {
  final int? id_timer;
  final int? id_socket;
  final DateTime? time;
  final bool status;

  TimerModel({this.id_timer = 0, this.id_socket = 0, this.time, this.status = false});

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id_timer: json['id_timer'],
      id_socket: json['id_socket'],
      time: json['time'],
      status: json['status'],
    );
  }
}
