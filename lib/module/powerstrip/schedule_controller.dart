import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/module/schedule/schedule_repository.dart';

class ScheduleController {
  final _scheduleRepository = ScheduleRepository();

  Future<MyArrayResponse?> getSchedule(String pwsKey) async {
    var scheduleObjectResponse = MyArrayResponse();

    // Get API data schedule
    await _scheduleRepository.getSchedule(pwsKey).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        scheduleObjectResponse = MyArrayResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data powerstrip berhasil dimuat";
        return scheduleObjectResponse;
      } else {
        return MyArrayResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return scheduleObjectResponse;
  }

  Future<MyResponse?> addSchedule(ScheduleModel schedule) async {
    // final prefs = await SharedPreferences.getInstance();
    MyResponse scheduleObjectResponse = MyResponse();

    // Get API data powerstrip
    await _scheduleRepository.addSchedule(schedule).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        scheduleObjectResponse = MyResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data powerstrip berhasil dimuat";
        return scheduleObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return scheduleObjectResponse;
  }

  Future<MyResponse?> deleteSchedule(int scheduleId) async {
    MyResponse scheduleObjectResponse = MyResponse();

    // Get API data powerstrip
    await _scheduleRepository.deleteSchedule(scheduleId).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        scheduleObjectResponse = MyResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Schedule berhasil dihapus";
        return scheduleObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return scheduleObjectResponse;
  }
}
