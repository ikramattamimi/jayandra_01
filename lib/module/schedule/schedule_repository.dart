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

  Future<http.Response> updateSchedule(ScheduleModel schedule) async {
    int status = schedule.socketStatus == true ? 1 : 0;
    String time = "${schedule.time!.hour}:${schedule.time!.minute}";
    return http.put(
      Uri.parse('${NetworkAPI.ip}/editSchedule/${schedule.pwsKey}/${schedule.socketNr}/$status'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          "schedule_time": time,
          "schedule_name": schedule.scheduleName,
          "day": schedule.days,
          "schedule_status": schedule.scheduleStatus,
        },
      ),
    );
  }

  Future<http.Response> updateScheduleStatus(ScheduleModel schedule) async {
    int status = schedule.socketStatus == true ? 1 : 0;
    return http.put(
      Uri.parse('${NetworkAPI.ip}/editSchedule/${schedule.pwsKey}/${schedule.socketNr}/$status'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          "schedule_status": schedule.socketStatus,
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
