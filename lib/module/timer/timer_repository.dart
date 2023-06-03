import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class TimerRepository {
  Future<http.Response> getTimer(int terminalId) async {
    return http.get(
      // Uri.parse('${NetworkAPI.ip}/getTimer/$terminalId'),
      Uri.parse('${NetworkAPI.ip}/getTimer/1'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> addTimer(TimerModel timer) async {
    // int updateStatus = status == true ? 1 : 0;
    String time = "${timer.time!.hour}:${timer.time!.minute}";
    return http.post(
      Uri.parse('${NetworkAPI.ip}/addTimer'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': timer.socketId.toString(),
          'time': time,
          'status': timer.status,
        },
      ),
    );
  }

  Future<http.Response> deleteTimer(int timerId) async {
    // int updateStatus = status == true ? 1 : 0;

    return http.post(
      Uri.parse('${NetworkAPI.ip}/deletetimer'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_timer': timerId.toString(),
        },
      ),
    );
  }
}
