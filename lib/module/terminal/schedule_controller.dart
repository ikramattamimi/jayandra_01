import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/module/schedule/schedule_repository.dart';

class ScheduleController {
  final _scheduleRepository = ScheduleRepository();

  Future<MyArrayResponse?> getSchedule(int terminalId) async {
    var scheduleObjectResponse = MyArrayResponse();

    // Get API data schedule
    await _scheduleRepository.getSchedule(terminalId).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Terminal
        scheduleObjectResponse = MyArrayResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data terminal berhasil dimuat";
        return scheduleObjectResponse;
      } else {
        return MyArrayResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return scheduleObjectResponse;
  }

  Future<MyResponse?> addSchedule(ScheduleModel schedule) async {
    // print('get terminal dipanggil');
    // final prefs = await SharedPreferences.getInstance();
    MyResponse scheduleObjectResponse = MyResponse();

    print('add schedule');

    // Get API data terminal
    await _scheduleRepository.addSchedule(schedule).then((value) {
      // print(value.statusCode);

      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Terminal
        scheduleObjectResponse = MyResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data terminal berhasil dimuat";
        return scheduleObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return scheduleObjectResponse;
  }

  // Future<MyResponse?> deleteSchedule(int scheduleId) async {
  //   // print('get terminal dipanggil');
  //   // final prefs = await SharedPreferences.getInstance();
  //   MyResponse scheduleObjectResponse = MyResponse();

  //   // print('add schedule');

  //   // Get API data terminal
  //   await _scheduleRepository.deleteSchedule(scheduleId).then((value) {
  //     // print(value.statusCode);

  //     if (value.statusCode == 200) {
  //       // Parse String json ke Map
  //       Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

  //       // Response dengan response.data berupa List dari objek Terminal
  //       scheduleObjectResponse = MyResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
  //       scheduleObjectResponse.message = "Schedule berhasil dihapus";
  //       return scheduleObjectResponse;
  //     } else {
  //       return MyResponse(code: 1, message: "Terjadi Masalah");
  //     }
  //   });
  //   return scheduleObjectResponse;
  // }
}
