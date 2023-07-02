import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class TimerRepository {
  Future<http.Response> getTimer(String pwsKey) async {
    return http.get(
      // Uri.parse('${NetworkAPI.ip}/getTimer/$pwsKey'),
      Uri.parse('${NetworkAPI.ip}/getTimer/$pwsKey'),
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
          'pws_serial_key': timer.pwsKey,
          'socket_number': timer.socketNr,
          'time': time,
          'status': timer.timerStatus,
        },
      ),
    );
  }

  Future<http.Response> deleteTimer(int socketNr, String pwsKey) async {
    // int updateStatus = status == true ? 1 : 0;

    return http.post(
      Uri.parse('${NetworkAPI.ip}/deletetimer'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {'socket_number': socketNr, 'pws_serial_key': pwsKey},
      ),
    );
  }
}
