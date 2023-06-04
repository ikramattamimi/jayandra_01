import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/module/schedule/schedule_repository.dart';
import 'package:provider/provider.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleModel> _schedules = [];

  List<ScheduleModel> get schedules => _schedules;

  late TerminalModel _terminal;

  TerminalModel get terminal => _terminal;

  final _scheduleRepository = ScheduleRepository();

  void addSchedule(ScheduleModel schedule) {
    _schedules.add(schedule);
    print("schedule ditambah ke provider");
    print(_schedules.length);
    notifyListeners();
  }

  void removeSchedule(int scheduleId) {
    var schedule = _schedules.firstWhere((element) => element.scheduleId == scheduleId);
    var index = _schedules.indexOf(schedule);
    _schedules.removeAt(index);
    notifyListeners();
  }

  set setTerminal(TerminalModel terminal) {
    _terminal = terminal;
    notifyListeners();
  }

  Future<void> initializeData() async {
    final scheduleModels = await createScheduleModelsFromApi();
    _schedules.addAll(scheduleModels);
    notifyListeners();
  }

  Future<List<ScheduleModel>> createScheduleModelsFromApi() async {
    var scheduleObjectResponse = MyArrayResponse();

    // Logika pemanggilan API untuk mendapatkan data schedule
    // Get API data schedule
    await _scheduleRepository.getSchedule(_terminal.id).then((value) {
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> scheduleMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Terminal
        scheduleObjectResponse = MyArrayResponse.fromJson(scheduleMapData, ScheduleModel.fromJson);
        scheduleObjectResponse.message = "Data terminal berhasil dimuat";
        // return scheduleObjectResponse.data;
      }
    });

    List<ScheduleModel> scheduleModels = [];
    for (ScheduleModel scheduleData in scheduleObjectResponse.data!) {
      scheduleData.terminalId = _terminal.id;
      scheduleModels.add(scheduleData);
    }

    return scheduleModels;
  }

  static ScheduleProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<ScheduleProvider>(context, listen: listen);
  }

  void changeScheduleStatus(int scheduleId, bool isScheduleOn) {
    final schedule = _schedules.firstWhere((schedule) => schedule.scheduleId == scheduleId);
    schedule.changeScheduleStatus(isScheduleOn);
    notifyListeners();
  }
}
