import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/module/powerstrip/schedule_controller.dart';
import 'package:jayandra_01/view/powerstrip/schedule/day_widget.dart';
import 'package:jayandra_01/view/powerstrip/time_picker.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/unique_int_generator.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key, required this.powerstripSchedule});

  final PowerstripSchedule powerstripSchedule;

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  /// ==========================================================================
  /// Page's Widgets
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Atur Schedule",
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
              updateSchedule();
            },
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            elevation: 0,
            color: Styles.secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      selectedSocket,
                      style: Styles.bodyTextBlack2,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  MyTimePicker(
                    title: "Waktu",
                    ifPickedTime: true,
                    currentTime: startTime,
                    onTimePicked: (x) {
                      setState(() {
                        startTime = x;
                      });
                    },
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repeatDay.join(', '),
                          style: Styles.bodyTextBlack3,
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getDaysWidget(),
                        ),
                      ],
                    ),
                  ),
                  const Gap(25),
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
                  const Gap(10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  TimeOfDay startTime = TimeOfDay.now();
  late bool isSocketOn;
  bool socketOn = true;
  bool socketOff = false;

  List<String> repeatDay = [];
  List<DayModel> daysIndo = DaysIndonesia.getDay();
  int jumlahrepeatDay = 0;
  String days = '';

  final _catatanController = TextEditingController();
  String selectedSocket = "";
  late PowerstripModel powerstrip;
  late ScheduleModel schedule;
  final _scheduleController = ScheduleController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// State Init
  @override
  void initState() {
    super.initState();
    powerstrip = widget.powerstripSchedule.powerstrip;
    schedule = widget.powerstripSchedule.schedule;
    startTime = schedule.time!;
    selectedSocket = powerstrip.sockets.firstWhere((element) => element.socketNr == schedule.socketNr).name;
    for (var dayName in schedule.days) {
      var schDay = daysIndo.firstWhere((element) => element.name == dayName);
      schDay.isSelected = true;
      addScheduleDay(schDay);
    }
    _catatanController.text = schedule.scheduleName;
    isSocketOn = schedule.socketStatus;
  }

  /// Change Radio
  void changeRadioStatusSelection(value) {
    setState(() {
      schedule.socketStatus = value;
    });
  }

  /// Add Schedule Day
  void addScheduleDay(DayModel day) {
    setState(() {
      var repeatAmount = daysIndo.where((element) => element.isSelected == true).length;
      if (day.isSelected) {
        daysIndo[day.id].isSelected = true;
      } else {
        repeatAmount != 0 ? daysIndo[day.id].isSelected = false : daysIndo[day.id].isSelected = true;
      }
      getRepeatDayName();
    });
  }

  /// Get Schedule Repeat Day
  void getRepeatDayName() {
    setState(() {
      repeatDay = [];
    });
    var repeatAmount = daysIndo.where((element) => element.isSelected == true).length;
    if (repeatAmount == 7) {
      setState(() {
        repeatDay.add("Setiap hari");
      });
      return;
    }
    for (var element in daysIndo) {
      if (element.isSelected) {
        setState(() {
          repeatDay.add(element.name);
        });
      }
    }
  }

  /// Days Widget
  List<Widget> getDaysWidget() {
    List<Widget> widgets = [];
    for (var element in daysIndo) {
      widgets.add(DayWidget(notifyParent: addScheduleDay, day: element));
    }
    return widgets;
  }

  /// Drop Down Socket
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var socket in powerstrip.sockets) {
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

  /// Panggil API updateSchedule
  updateSchedule() async {
    ScheduleModel newValSchedule = ScheduleModel(
      pwsKey: powerstrip.pwsKey,
      socketNr: schedule.socketNr,
      time: startTime,
      socketStatus: isSocketOn,
      scheduleStatus: true,
      days: repeatDay.isNotEmpty && repeatDay[0] == "Setiap hari"
          ? [
              "Senin",
              "Selasa",
              "Rabu",
              "Kamis",
              "Jumat",
              "Sabtu",
              "Minggu",
            ]
          : repeatDay,
      scheduleName: _catatanController.text,
    );

    schedule.days = newValSchedule.days;
    schedule.time = newValSchedule.time;
    schedule.scheduleName = newValSchedule.scheduleName;
    schedule.scheduleStatus = true;

    await _scheduleController.updateSchedule(newValSchedule).then((value) {
      // var scheduledTime = DateTime.now().add(Duration(hours: startTime.hour - DateTime.now().hour, minutes: startTime.minute - DateTime.now().minute));
      var now = DateTime.now();
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
      );
      var socket = powerstrip.sockets.firstWhere((element) => element.socketNr == schedule.socketNr);
      Logger().i(value!.code);

      // Jika schedule aktif
      if (newValSchedule.scheduleStatus) {
        // Atur Schedule
        AndroidAlarmManager.oneShotAt(
          scheduledTime,
          UniqueIntGenerator().generateUniqueInt(),
          getScheduleNotification,
          params: {
            'socketName': socket.name,
            'socketId': socket.socketNr,
            'pwsKey': socket.pwsKey,
            'status': newValSchedule.socketStatus,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule berhasil ditambahkan'),
        ),
      );

      context.pop();
    });
  }
}

getScheduleNotification(int idTimer, Map<String, dynamic> socket) async {
  await Workmanager().registerOneOffTask(
    "schedule.powerstrip${socket['pwsKey']}.socket${socket['socketName']}",
    "changeSocketStatusSchedule",
    inputData: {
      'socketId': socket['socketId'],
      'pwsKey': socket['pwsKey'],
      'status': socket['status'],
      // 'timerId': socket['timerId'],
    },
    // initialDelay: Duration(seconds: 5),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(networkType: NetworkType.connected),
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
  );

  UniqueIntGenerator generator = UniqueIntGenerator();
  var status = socket['status'] ? "aktif" : "nonaktif";
  NotificationService().showNotification(
    id: generator.generateUniqueInt(),
    title: "Jadwal untuk ${status}kan socket ${socket['socketName']}",
    body: "Schedule selesai untuk Socket ${socket['socketName']}. Socket sudah $status",
  );
}
