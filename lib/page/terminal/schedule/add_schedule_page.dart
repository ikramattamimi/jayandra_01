import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/models/days_indonesia.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/schedule_controller.dart';
import 'package:jayandra_01/page/terminal/schedule/day_view.dart';
import 'package:jayandra_01/page/terminal/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key, required this.terminal});

  final TerminalModel terminal;

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  /// ==========================================================================
  /// Page's Widgets
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
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
              addSchedule();
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
                        print("The picked time is: $x");
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

  var _catatanController = TextEditingController();
  String selectedSocket = "";
  late TerminalModel terminal;
  var _scheduleController = ScheduleController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// State Init
  @override
  void initState() {
    super.initState();
    terminal = widget.terminal;
    selectedSocket = widget.terminal.sockets![0].socketId.toString();
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
      print(repeatAmount);
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
    // print(repeatAmount);
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
      widgets.add(DayView(notifyParent: addScheduleDay, day: element));
    }
    return widgets;
  }

  /// Drop Down Socket
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var socket in terminal.sockets!) {
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

  addSchedule() async {
    ScheduleModel schedule = ScheduleModel(
      id_socket: int.parse(selectedSocket),
      time: startTime,
      status: isSocketOn,
      days: daysIndo,
      note: _catatanController.text,
    );
    MyResponse? addScheduleResponse = await _scheduleController.addSchedule(schedule);
    print(addScheduleResponse);
  }
}
