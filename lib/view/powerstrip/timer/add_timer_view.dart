import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/powerstrip/timer_controller.dart';
import 'package:jayandra_01/view/powerstrip/time_picker.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/unique_int_generator.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';
import 'package:workmanager/workmanager.dart';

// import 'package:timezone/timezone.dart' as tz;
late TimerModel timerToChange;
late TimerModel timer;
late PowerstripModel powerstrip;

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({
    super.key,
    required this.powerstripTimer,
  });
  final PowerstripTimer powerstripTimer;

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  /// ==========================================================================
  /// Widget Page
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Atur Timer",
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.secondaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              updateTimer(timer.pwsKey, timer.socketNr, timer);
            },
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          WhiteContainer(
            margin: 16,
            padding: 16,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    selectedValue,
                    style: Styles.bodyTextBlack2,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                MyTimePicker(
                  title: "Lama timer",
                  ifPickedTime: true,
                  currentTime: endTime,
                  onTimePicked: (x) {
                    setState(() {
                      endTime = x;
                    });
                  },
                ),
                const Gap(10),
                SizedBox(
                  height: 48,
                  child: TextField(
                    maxLength: 20,
                    controller: _catatanController,
                    decoration: InputDecoration(
                      hintText: "Catatan",
                      hintStyle: Styles.bodyTextGrey2,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ==========================================================================
  /// Deklarasi Variable
  /// ==========================================================================
  var timerMinute = 0;
  var timerHour = 0;
  String selectedOption = "";
  String selectedValue = "";
  bool isSwitched = true;
  var timerStatus = "Aktif";
  PowerstripModel? powerstrip;
  final _timerController = TimerController();
  late TimeOfDay endTime;
  final _catatanController = TextEditingController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  @override
  void initState() {
    super.initState();
    powerstrip = widget.powerstripTimer.powerstrip;
    timer = widget.powerstripTimer.timer;
    selectedValue = powerstrip!.sockets.firstWhere((element) => element.socketNr == timer.socketNr).name;
    endTime = timer.time!;
    _catatanController.text = timer.timerName;
  }

  updateTimer(String pwsKey, int socketNr, TimerModel timer) async {
    timer.time = endTime;
    timer.timerName = _catatanController.text;
    await _timerController.updateTimer(pwsKey, socketNr, timer).then((value) {
      var scheduledTime = DateTime.now().add(Duration(hours: endTime.hour, minutes: endTime.minute));
      var socket = powerstrip!.sockets.firstWhere((element) => element.socketNr == socketNr);

      if (timer.timerStatus) {
        AndroidAlarmManager.oneShotAt(
          scheduledTime,
          timer.socketNr,
          setTimerNotification,
          params: {
            'socketName': socket.name,
            'socketId': socket.socketNr,
            'pwsKey': socket.pwsKey,
            'status': socket.status,
            // 'timerId': newTimer.timerId,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer berhasil diupdate'),
        ),
      );

      context.pop();
    });
  }

  setTime(int hour, int minute) {
    setState(() {
      timerHour = hour;
      timerMinute = minute;
    });
  }
}

setTimerNotification(int idTimer, Map<String, dynamic> socket) async {
  await Workmanager().registerOneOffTask(
    "timer.powerstrip${socket['pwsKey']}.socket${socket['socketName']}",
    "changeSocketStatusTimer",
    inputData: {
      'socketId': socket['socketId'],
      'pwsKey': socket['pwsKey'],
      'status': false,
      // 'timerId': socket['timerId'],
    },
    // initialDelay: Duration(seconds: 5),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(networkType: NetworkType.connected),
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
  );

  NotificationService().showNotification(
    id: 10 + int.parse(socket['socketId'].toString()),
    title: "Timer selesai",
    body: "Timer selesai untuk Socket ${socket['socketName']}. Socket sudah dimatikan",
  );
}
