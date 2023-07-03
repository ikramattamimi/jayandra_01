import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/powerstrip/timer_controller.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/view/powerstrip/time_picker.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/unique_int_generator.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
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
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Ubah Timer",
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
                SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        timerStatus,
                        style: Styles.bodyTextBlack2,
                      ),
                      SizedBox(
                        width: 45,
                        height: 30,
                        child: Switch(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: timer.timerStatus,
                          onChanged: (value) {
                            setState(() {
                              timer.timerStatus = value;
                              timerStatus = timer.timerStatus ? "Aktif" : "Nonaktif";
                            });
                          },
                          activeColor: Styles.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Gap(16),
                // DropdownButtonFormField(
                //   focusColor: Styles.accentColor,
                //   decoration: const InputDecoration.collapsed(
                //     hintText: '',
                //   ),
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.symmetric(vertical: 16),
                //   validator: (value) => value == null ? "Select a country" : "null",
                //   // dropdownColor: Colors.blueAccent,
                //   value: selectedValue,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       selectedValue = newValue!;
                //     });
                //   },
                //   items: dropdownItems,
                // ),
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
      TimerModel newTimer = timer;
      // var scheduledTime = DateTime.now().add(Duration(hours: endTime.hour, minutes: endTime.minute));
      // var socket = powerstrip!.sockets.firstWhere((element) => element.socketNr == int.parse(selectedValue));
      // timerToChange.logger();
      // AndroidAlarmManager.oneShotAt(
      //   scheduledTime,
      //   timer.socketNr ?? 12,
      //   setTimerNotification,
      //   params: {
      //     'socketName': socket.name,
      //     'socketId': socket.socketNr,
      //     'pwsKey': socket.pwsKey,
      //     'status': socket.status,
      //     // 'timerId': newTimer.timerId,
      //   },
      // );

      // timerProvider.addTimer(newTimer); // updatetimer
      // timer.logger();
      // newTimer.logger();
      // Logger().i(timerProvider.timers);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer berhasil diupdate'),
        ),
      );
    });
  }

  /// Simpan timer ke database
  addTimer(TimerProvider timerProvider) async {
    TimerModel timer = TimerModel(
      pwsKey: powerstrip!.pwsKey,
      socketNr: int.parse(selectedValue),
      time: endTime,
      timerStatus: isSwitched,
    );

    await _timerController.addTimer(timer).then((value) {
      TimerModel newTimer = timer;
      var scheduledTime = DateTime.now().add(Duration(hours: endTime.hour, minutes: endTime.minute));
      var socket = powerstrip!.sockets.firstWhere((element) => element.socketNr == int.parse(selectedValue));
      // timerToChange.logger();
      AndroidAlarmManager.oneShotAt(
        scheduledTime,
        timer.socketNr ?? 12,
        setTimerNotification,
        params: {
          'socketName': socket.name,
          'socketId': socket.socketNr,
          'pwsKey': socket.pwsKey,
          'status': socket.status,
          // 'timerId': newTimer.timerId,
        },
      );

      timerProvider.addTimer(newTimer);
      timer.logger();
      newTimer.logger();
      Logger().i(timerProvider.timers);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer berhasil ditambahkan'),
        ),
      );

      context.pop();
    });

    // Workmanager().cancelByUniqueName(uniqueName)
  }

  /// Getter nama socket untuk dropdown
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var socket in powerstrip!.sockets) {
      menuItems.add(
        DropdownMenuItem(
          value: socket.socketNr.toString(),
          child: Text(
            socket.name,
            style: Styles.bodyTextBlack2,
          ),
        ),
      );
    }
    return menuItems;
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

  var generator = UniqueIntGenerator();
  NotificationService().showNotification(
    id: generator.generateUniqueInt(),
    title: "Timer selesai",
    body: "Timer selesai untuk Socket ${socket['socketName']}. Socket sudah dimatikan",
  );
}
