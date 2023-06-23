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
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

// import 'package:timezone/timezone.dart' as tz;
TimerModel? timerToChange;

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({super.key, required this.powerstrip});
  final PowerstripModel powerstrip;

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
          "Tambah Timer",
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
              addTimer(timerProvider);
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
                        socketStatus,
                        style: Styles.bodyTextBlack2,
                      ),
                      SizedBox(
                        width: 45,
                        height: 30,
                        child: Switch(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              socketStatus = isSwitched ? "Aktif" : "Nonaktif";
                            });
                          },
                          activeColor: Styles.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Gap(16),
                DropdownButtonFormField(
                  focusColor: Styles.accentColor,
                  decoration: const InputDecoration.collapsed(
                    hintText: '',
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  validator: (value) => value == null ? "Select a country" : "null",
                  // dropdownColor: Colors.blueAccent,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems,
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
  var socketStatus = "Aktif";
  PowerstripModel? powerstrip;
  final _timerController = TimerController();
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 1);

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  @override
  void initState() {
    super.initState();
    powerstrip = widget.powerstrip;
    selectedValue = widget.powerstrip.sockets[0].socketId.toString();
  }

  /// Simpan timer ke database
  addTimer(TimerProvider timerProvider) async {
    TimerModel timer = TimerModel(
      socketId: int.parse(selectedValue),
      time: endTime,
      status: isSwitched,
    );

    timer.powerstripId = powerstrip!.id;

    await _timerController.addTimer(timer).then((value) {
      timerToChange = timer;
      var scheduledTime = DateTime.now().add(Duration(hours: endTime.hour, minutes: endTime.minute));
      var socket = powerstrip!.sockets.firstWhere((element) => element.socketId == int.parse(selectedValue));
      AndroidAlarmManager.oneShotAt(
        scheduledTime,
        value!.data.timerId ?? 12,
        getTimerNotification,
        params: {
          'socketName': socket.name,
          'socketId': socket.socketId,
          'powerstripId': socket.powerstripId,
          'status': socket.status,
        },
      );

      timerProvider.addTimer(timer);

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
          value: socket.socketId.toString(),
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

getTimerNotification(int idTimer, Map<String, dynamic> socket) async {
  await Workmanager().registerOneOffTask(
    "timer.powerstrip${socket['powerstripId']}.socket${socket['socketName']}",
    "changeSocketStatusTimer",
    inputData: {
      'socketId': socket['socketId'],
      'powerstripId': socket['powerstripId'],
      'status': false,
    },
    // initialDelay: Duration(seconds: 5),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(networkType: NetworkType.connected),
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
  );

  UniqueIntGenerator generator = UniqueIntGenerator();
  NotificationService().showAlarm(
    id: generator.generateUniqueInt(),
    title: "Timer selesai",
    body: "Timer selesai untuk Socket ${socket['socketName']}. Segera nonaktifkan socket supaya tagihan tidak membengkak!",
  );
}
