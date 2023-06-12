import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/schedule_controller.dart';
import 'package:jayandra_01/view/powerstrip/schedule/day_widget.dart';
import 'package:jayandra_01/view/powerstrip/time_picker.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/unique_int_generator.dart';
import 'package:provider/provider.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key, required this.powerstrip});

  final PowerstripModel powerstrip;

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  /// ==========================================================================
  /// Page's Widgets
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Tambah Jadwal",
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.secondaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Styles.primaryColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
            );
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addSchedule(scheduleProvider);
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Jadwal Untuk",
                    style: Styles.bodyTextBlack2,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => changeRadioStatusSelection(socketOn),
                        child: Row(
                          children: [
                            Radio(
                              value: socketOn,
                              groupValue: isSocketOn,
                              onChanged: (bool? value) {
                                // setState(() {
                                changeRadioStatusSelection(value);
                                // });
                              },
                            ),
                            Text(
                              "Aktif",
                              style: Styles.bodyTextBlack2,
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () => changeRadioStatusSelection(socketOff),
                        child: Row(
                          children: [
                            Radio(
                              value: socketOff,
                              groupValue: isSocketOn,
                              onChanged: (bool? value) {
                                // setState(() {
                                changeRadioStatusSelection(value);
                                // });
                              },
                            ),
                            Text(
                              "Nonaktif",
                              style: Styles.bodyTextBlack2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            elevation: 0,
            color: Styles.secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                  const Gap(10),
                  DropdownButtonFormField(
                    focusColor: Colors.white,
                    decoration: const InputDecoration.collapsed(
                      hintText: '',
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    validator: (value) => value == null ? "Select a country" : "null",
                    // dropdownColor: Colors.blueAccent,
                    value: selectedSocket,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSocket = newValue!;
                      });
                    },
                    items: dropdownItems,
                  ),
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
  int dayOfWeek = DateTime.now().weekday;
  bool isSocketOn = true;
  bool socketOn = true;
  bool socketOff = false;
  List<String> repeatDay = [];
  List<DayModel> daysIndo = DaysIndonesia.getDay();
  int jumlahrepeatDay = 0;
  String days = '';

  final _catatanController = TextEditingController();
  String selectedSocket = "";
  late PowerstripModel powerstrip;
  final _scheduleController = ScheduleController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// State Init
  @override
  void initState() {
    super.initState();
    powerstrip = widget.powerstrip;
    selectedSocket = widget.powerstrip.sockets![0].socketId.toString();
    daysIndo[dayOfWeek - 1].isSelected = true;
    getRepeatDay();
  }

  /// Change Radio
  void changeRadioStatusSelection(value) {
    setState(() {
      isSocketOn = value;
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
      getRepeatDay();
    });
  }

  /// Get Schedule Repeat Day
  void getRepeatDay() {
    repeatDay = [];
    var repeatAmount = daysIndo.where((element) => element.isSelected == true).length;
    if (repeatAmount == 7) {
      repeatDay.add("Setiap hari");
      return;
    }
    for (var element in daysIndo) {
      if (element.isSelected) {
        repeatDay.add(element.name);
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
    for (var socket in powerstrip.sockets!) {
      menuItems.add(
        DropdownMenuItem(
          value: socket.socketId.toString(),
          child: Text(
            socket.name!,
            style: Styles.bodyTextBlack2,
          ),
        ),
      );
    }
    return menuItems;
  }

  /// Panggil API addSchedule
  addSchedule(ScheduleProvider scheduleProvider) async {
    ScheduleModel schedule = ScheduleModel(
      sockeId: int.parse(selectedSocket),
      time: startTime,
      status: isSocketOn,
      scheduleStatus: isSocketOn,
      days: daysIndo,
      note: _catatanController.text,
    );

    schedule.powerstripId = powerstrip.id;

    await _scheduleController.addSchedule(schedule).then((value) {
      var scheduledTime = DateTime.now().add(const Duration(seconds: 5));
      var socket = powerstrip.sockets!.firstWhere((element) => element.socketId == int.parse(selectedSocket));
      AndroidAlarmManager.oneShotAt(
        scheduledTime,
        UniqueIntGenerator().generateUniqueInt(),
        getScheduleNotification,
        params: {'socketName': socket.name, 'status': schedule.scheduleStatus},
      );

      scheduleProvider.addSchedule(schedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule berhasil ditambahkan'),
        ),
      );

      context.pop();
    });
    await _scheduleController.addSchedule(schedule);
  }
}

getScheduleNotification(int idTimer, Map<String, dynamic> socket) {
  UniqueIntGenerator generator = UniqueIntGenerator();
  var status = socket['status'] ? "aktif" : "nonaktif";
  NotificationService().showAlarm(
    id: generator.generateUniqueInt(),
    title: "Jadwal untuk ${status}kan socket ${socket['socketName']}",
    body: "Sudah saatnya untuk ${status}kan socket ${socket['socketName']}. Segera ${status}kan socket!",
  );
}
