import 'dart:convert';

import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/timer/timer_repository.dart';

class TimerController {
  final _timerRepository = TimerRepository();

  Future<MyArrayResponse?> getTimer(int powerstripId) async {
    var timerObjectResponse = MyArrayResponse();

    // Get API data timer
    await _timerRepository.getTimer(powerstripId).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> timerMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        timerObjectResponse = MyArrayResponse.fromJson(timerMapData, TimerModel.fromJson);
        timerObjectResponse.message = "Data powerstrip berhasil dimuat";
        return timerObjectResponse;
      } else {
        return MyArrayResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return timerObjectResponse;
  }

  Future<MyResponse?> addTimer(TimerModel timer) async {
    // print('get powerstrip dipanggil');
    // final prefs = await SharedPreferences.getInstance();
    MyResponse timerObjectResponse = MyResponse();

    // print('add timer');

    // Get API data powerstrip
    await _timerRepository.addTimer(timer).then((value) {
      // print(value.statusCode);

      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> timerMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        timerObjectResponse = MyResponse.fromJson(timerMapData, TimerModel.fromJson);
        timerObjectResponse.message = "Data powerstrip berhasil dimuat";
        return timerObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return timerObjectResponse;
  }

  Future<MyResponse?> deleteTimer(int timerId) async {
    // print('get powerstrip dipanggil');
    // final prefs = await SharedPreferences.getInstance();
    MyResponse timerObjectResponse = MyResponse();

    // print('add timer');

    // Get API data powerstrip
    await _timerRepository.deleteTimer(timerId).then((value) {
      // print(value.statusCode);

      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> timerMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        timerObjectResponse = MyResponse.fromJson(timerMapData, TimerModel.fromJson);
        timerObjectResponse.message = "Timer berhasil dihapus";
        return timerObjectResponse;
      } else {
        return MyResponse(code: 1, message: "Terjadi Masalah");
      }
    });
    return timerObjectResponse;
  }
}
