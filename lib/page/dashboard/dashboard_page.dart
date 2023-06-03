import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/terminal/terminal_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/page/report/report_view.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/terminal_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final terminalProvider = Provider.of<TerminalProvider>(context);

    // initWidgets(userModel, terminalProvider);
    var terminals = terminalProvider.terminals;
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
                      'Halo ${userModel.name}!',
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
            child: Row(children: _getTerminalWidget(terminals)),
          )
        ],
      ),
    );
  }

  List<Widget> _getTerminalWidget(List<TerminalModel> terminals) {
    if (terminals != []) {
      _terminalWidgets = [];
      for (var terminal in terminals) {
        // print(terminal.totalActiveSocket);
        _terminalWidgets!.add(
          TerminalView(
            terminalId: terminal.id,
            // terminalIcon: Icons.bed,
            // terminal: terminal,
          ),
        );
      }
    }
    return _terminalWidgets!;
  }

  String? userName;
  // final _controller = TerminalController();
  // List<TerminalModel>? _terminals = [];
  List<Widget>? _terminalWidgets = [];

  /// Response pemanggilan API yang sudah dalam bentuk objek [TerminalResponse]
  // late TerminalResponse? _terminalObjectResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _isTerminalNull();

    BuildContext myContext = context;

    // For get terminal
    final userModel = Provider.of<UserModel>(myContext, listen: false);
    final terminalProvider = Provider.of<TerminalProvider>(myContext, listen: false);
    final timerProvider = Provider.of<TimerProvider>(myContext, listen: false);
    initModels(userModel, terminalProvider, timerProvider);
  }

  void initModels(UserModel userModel, TerminalProvider terminalProvider, TimerProvider timerProvider) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isUserLoggedIn') ?? false) {
      UserModel user = UserModel(
        id: prefs.getInt('user_id')!,
        name: prefs.getString('user_name')!,
        email: prefs.getString('email')!,
        electricityclass: prefs.getString('electricityclass')!,
      );
      if (userModel.email == "") {
        userModel.updateUser(user);
      }
      if (terminalProvider.terminals.isEmpty) {
        terminalProvider.initializeData(user.id).then((value) {

          // For get timer
          for (var terminal in terminalProvider.terminals) {
            timerProvider.setTerminal = terminal;
            timerProvider.initializeData();
          }
        });
      }
      // return terminalProvider.terminals;
    }
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
  // void _getTerminal() async {
  //   try {
  //     _terminalObjectResponse = await _controller.getTerminal().then((value) {
  //       setState(() {
  //         if (value!.data != null) {
  //           _terminals = value.data;
  //         } else {
  //           _terminals = null;
  //           _terminalWidgets = [
  //             SizedBox(
  //               height: 50,
  //               width: MediaQuery.of(context).size.width,
  //               child: Center(
  //                 child: Text(
  //                   "Belum ada perangkat",
  //                   style: Styles.bodyTextBlack,
  //                 ),
  //               ),
  //             ),
  //           ];
  //         }
  //         _getTerminalWidget();
  //       });
  //       return null;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

void getNotification() {
  print("Get Notification");
  NotificationService().showNotification(title: "Halo", body: "Bjirr");
}
