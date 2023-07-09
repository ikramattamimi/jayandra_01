import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/module/schedule/schedule_repository.dart';
import 'package:provider/provider.dart';

class ScheduleProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<ScheduleModel> _schedules = [];

  List<ScheduleModel> get schedules => _schedules;

  late PowerstripModel _powerstrip;

  PowerstripModel get powerstrip => _powerstrip;

  final _scheduleRepository = ScheduleRepository();

  void addSchedule(ScheduleModel schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void removeSchedule(ScheduleModel selSchedule) {
    var schedule = _schedules.firstWhere((element) => element == selSchedule);
    var index = _schedules.indexOf(schedule);
    _schedules.removeAt(index);
    notifyListeners();
  }

  set setPowerstrip(PowerstripModel powerstrip) {
    _powerstrip = powerstrip;
    notifyListeners();
  }

  clearSchedules() {
    _schedules.clear();
    notifyListeners();
  }

  Future<void> initializeData() async {
    await createScheduleModelsFromApi();
    notifyListeners();
  }

  createScheduleModelsFromApi() async {
    var scheduleObjectResponse = MyArrayResponse();

    // Logika pemanggilan API untuk mendapatkan data schedule
    // Get API data schedule
    await _scheduleRepository.getSchedule(_powerstrip.pwsKey).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Powerstrip
        scheduleObjectResponse = MyArrayResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data powerstrip berhasil dimuat";
        // return scheduleObjectResponse.data;
      }
    });
    for (ScheduleModel scheduleData in scheduleObjectResponse.data!) {
      if (scheduleData.pwsKey == _powerstrip.pwsKey) {
        // scheduleData.logger();
        _schedules.add(scheduleData);
      }
    }
  }

  static ScheduleProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<ScheduleProvider>(context, listen: listen);
  }

  void changeScheduleStatus(ScheduleModel selSchedule, bool isScheduleOn) {
    final schedule = _schedules.firstWhere((schedule) => schedule == selSchedule);
    schedule.changeScheduleStatus(isScheduleOn);
    notifyListeners();
  }
}
