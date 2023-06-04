import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/schedule_model.dart';
// import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class ScheduleRepository {
  Future<http.Response> getSchedule(int terminalId) async {
    return http.get(
      // Uri.parse('${NetworkAPI.ip}/getTimer/$terminalId'),
      Uri.parse('${NetworkAPI.ip}/getSchedule/$terminalId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> addSchedule(ScheduleModel schedule) async {
    // int updateStatus = status == true ? 1 : 0;
    String time = "${schedule.time!.hour}:${schedule.time!.minute}";
    List<String> days = [];
    for (var element in schedule.days) {
      if (element.isSelected) {
        days.add(element.name);
      }
    }
    return http.post(
      Uri.parse('${NetworkAPI.ip}/addschedule'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': schedule.sockeId.toString(),
          'status': schedule.status,
          'time': time,
          'note': schedule.note,
          'day': days,
        },
      ),
    );
  }
}
