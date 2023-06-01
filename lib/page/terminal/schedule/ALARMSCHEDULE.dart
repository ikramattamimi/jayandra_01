// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class AlarmPage extends StatefulWidget {
//   @override
//   _AlarmPageState createState() => _AlarmPageState();
// }

// class _AlarmPageState extends State<AlarmPage> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // List hari yang akan diulang alarm
//   List<int> repeatDays = [1, 3, 5]; // Senin, Rabu, Jumat

//   @override
//   void initState() {
//     super.initState();

//     // Inisialisasi plugin local notifications
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsIOS = IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);

//     // Atur alarm untuk hari ini
//     scheduleNextAlarm();
//   }

//   Future<void> onSelectNotification(String? payload) async {
//     // Aksi yang diambil ketika notifikasi ditekan
//   }

//   void scheduleNextAlarm() async {
//     var now = DateTime.now();
//     var currentDay = now.weekday;

//     // Cek apakah hari saat ini ada dalam list repeatDays
//     if (repeatDays.contains(currentDay)) {
//       // Buat jadwal alarm
//       var scheduledTime = tz.TZDateTime.from(
//           now.add(Duration(seconds: 5)), tz.local); // Contoh: 5 detik dari sekarang

//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//           'alarm_channel', 'Alarm', 'Channel for alarm notifications',
//           importance: Importance.max, priority: Priority.high);
      
//       var iOSPlatformChannelSpecifics =
//           IOSNotificationDetails(sound: 'alarm_sound.wav');
      
//       var platformChannelSpecifics = NotificationDetails(
//           android: androidPlatformChannelSpecifics,
//           iOS: iOSPlatformChannelSpecifics);

//       // Atur jadwal alarm menggunakan flutterLocalNotificationsPlugin
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0, // ID notifikasi
//         'Alarm', // Judul notifikasi
//         'Waktunya alarm!', // Isi notifikasi
//         scheduledTime,
//         platformChannelSpecifics,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         androidAllowWhileIdle: true,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//         payload: 'Alarm',
//         androidAllowWhileIdle: true,
//       );
//     }

//     // Atur alarm untuk hari berikutnya dalam repeatDays
//     var nextDay = repeatDays.firstWhere((day) => day > currentDay,
//         orElse: () => repeatDays.first);
//     var daysUntilNextAlarm = nextDay - currentDay;
//     var nextAlarmDate = now.add(Duration(days: daysUntilNextAlarm));

//     var nextAlarmTime = tz.TZDateTime.from(nextAlarmDate, tz.local);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1, // ID notifikasi
//       'Next Alarm', // Judul notifikasi
//       'Jadwal alarm berikutnya', // Isi notifikasi
//       nextAlarmTime,
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//       payload: 'Next Alarm',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alarm Page'),
//       ),
//       body: Center(
//         child: Text('Alarm diatur untuk hari tertentu.'),
//       ),
//     );
//   }
// }

// void main() {
//   tz.initializeTimeZones();
//   runApp(MaterialApp(
//     home: AlarmPage(),
//   ));
// }
