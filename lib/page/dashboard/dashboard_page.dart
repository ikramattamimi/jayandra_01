import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/page/report/report_view.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/terminal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Widget ini menampilkan halaman Dashboard
class DashboardPage extends StatefulWidget {
  // final User user;
  // const DashboardPage({super.key, required this.user});
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  final _controller = TerminalController();
  List<TerminalModel>? _terminals = [];
  List<Widget>? _terminalWidgets = [];

  /// Response pemanggilan API yang sudah dalam bentuk objek [TerminalResponse]
  late TerminalResponse? _terminalObjectResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _isTerminalNull();
    _getTerminal();

    // print(widget.user);
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  void _isTerminalNull() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('terminal') == null) {
      _terminalWidgets = [
        SizedBox(
          height: 140,
          width: 170,
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Styles.secondaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(color: Styles.accentColor),
            ),
          ),
        ),
      ];
    }
  }

  /// Mengambil data terminal
  ///
  /// Jika data terminal berhasil didapat ketika login data akan
  /// diambil dari [SharedPreferences].
  ///
  /// Sebaliknya, data terminal akan diambil dengan melakukan pemanggilan
  /// API getTerminal pada [LoginController]
  void _getTerminal() async {
    try {
      _terminalObjectResponse = await _controller.getTerminal().then((value) {
        setState(() {
          if (value!.data != null) {
            _terminals = value.data;
          } else {
            _terminals = null;
            _terminalWidgets = [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Belum ada perangkat",
                    style: Styles.bodyTextBlack,
                  ),
                ),
              ),
            ];
          }
          _getTerminalWidget();
        });
        return null;
      });
    } catch (e) {
      print(e);
    }
  }

  void _getTerminalWidget() {
    if (_terminals != null) {
      _terminalWidgets = [];
      for (var terminal in _terminals!) {
        print(terminal.totalActiveSocket);
        _terminalWidgets!.add(
          TerminalView(
            terminalIcon: Icons.bed,
            terminal: terminal,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (userName != null) ? "Halo $userName!" : "Halo",
                      style: Styles.headingStyle1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // final now = DateTime.now();
                            // final scheduledDate = tz.TZDateTime.from(
                            //   now.add(const Duration(seconds: 5)), // Set the notification for tomorrow
                            //   tz.local,
                            // );
                            // final time = Time(10, 0, 0); // Set the time for the notification (e.g., 10:00 AM)
                            // final schedule = DailyTimeIntervalSchedule(
                            //   startTime: TimeOfDay.fromDateTime(time).toDuration(),
                            //   endTime: TimeOfDay.fromDateTime(time).toDuration(),
                            //   interval: const Duration(days: 1), // Repeat daily
                            // );
                            AndroidAlarmManager.oneShotAt(
                                DateTime.now().add(
                                  Duration(minutes: 1),
                                ),
                                1,
                                getNotification,
                                wakeup: true);
                            // NotificationService().showNotificationAtTime(title: "Halo", body: "Notif", scheduledDate: scheduledDate);
                          },
                          icon: Icon(
                            Icons.notifications_rounded,
                            size: 30,
                            color: Styles.textColor3,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context.pushNamed('add_device'),
                          icon: Icon(
                            CarbonIcons.add_filled,
                            size: 30,
                            color: Styles.accentColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Gap(16),
                // ============== Laporan Penggunaan
                const ReportView(),
              ],
            ),
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Perangkat Anda",
              style: Styles.headingStyle2,
              textAlign: TextAlign.start,
            ),
          ),
          const Gap(24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _terminalWidgets!),
          )
        ],
      ),
    );
  }
}

void getNotification() {
  print("Get Notification");
  NotificationService().showNotification(title: "Halo", body: "Bjirr");
}
