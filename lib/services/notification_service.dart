import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('flutter_logo');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  alarmDetails({bool isAlarm = false}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'SSsSSS',
        importance: Importance.max,
        priority: Priority.max,
        sound: const RawResourceAndroidNotificationSound('bell'),
        playSound: true,
        ticker: 'ticker',
        additionalFlags: isAlarm ? Int32List.fromList(<int>[4]) : null,
      ),
    );
  }

  notificationDetails({bool isAlarm = false}) {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId2',
        'channelName2',
        channelDescription: 'SSsSSS',
        sound: RawResourceAndroidNotificationSound('bell'),
        playSound: true,
      ),
    );
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future showAlarm({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, alarmDetails(isAlarm: true));
  }

  Future showNotificationAtTime({int id = 0, required String title, required String body, String? payLoad, required TZDateTime scheduledDate}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      alarmDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Future showScheduleNotification({}) async {
  //   return notificationsPlugin.
  // }
}
