import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlarmManagerService {
  Future<void> initAlarmManager() async {
    await AndroidAlarmManager.initialize();
  }
}
