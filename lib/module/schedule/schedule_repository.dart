import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/schedule_model.dart';
// import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class ScheduleRepository {
  Future<http.Response> getSchedule(String pwsKey) async {
    return http.get(
      // Uri.parse('${NetworkAPI.ip}/getTimer/$pwsKey'),
      Uri.parse('${NetworkAPI.ip}/getSchedule/$pwsKey'),
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
          "socket_number": schedule.socketNr,
          "pws_serial_key": schedule.pwsKey,
          "schedule_status": schedule.scheduleStatus,
          "schedule_socket_status": schedule.socketStatus,
          "schedule_time": time,
          "schedule_name": schedule.note,
          "day": days
        },
      ),
    );
  }

  Future<http.Response> deleteSchedule(String pwsKey, int socketNr) async {
    // int updateStatus = status == true ? 1 : 0;

    return http.post(
      Uri.parse('${NetworkAPI.ip}/deleteschedule'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          "socket_number": socketNr,
          "pws_serial_key": pwsKey,
        },
      ),
    );
  }
}
