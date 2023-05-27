import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/module/terminal/timer_controller.dart';
import 'package:jayandra_01/page/terminal/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/list_tile_view.dart';
import 'package:jayandra_01/widget/white_container.dart';

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({super.key, required this.terminal});
  final Terminal terminal;

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  var timerMinute = 0;
  var timerHour = 0;
  String selectedOption = "";
  String selectedValue = "";
  final _dropdownFormKey = GlobalKey<FormState>();
  bool isSwitched = true;
  var socketStatus = "Aktif";
  Terminal? terminal;
  final _terminalController = TerminalController();
  final _timerController = TimerController();

  @override
  void initState() {
    super.initState();
    terminal = widget.terminal;
    selectedValue = widget.terminal.sockets[0].id_socket.toString();
    print(terminal!.name);
  }

  addTimer() async {
    TimerModel timer = TimerModel(
      id_socket: int.parse(selectedValue),
      time: TimeOfDay(hour: timerHour, minute: timerMinute),
      status: isSwitched,
    );
    MyResponse? addTimerResponse = await _timerController.addTimer(timer);
    print(addTimerResponse);
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var socket in terminal!.sockets) {
      menuItems.add(
        DropdownMenuItem(
          value: socket.id_socket.toString(),
          child: Text(
            socket.name!,
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

  @override
  Widget build(BuildContext context) {
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
              addTimer();
            },
            icon: Icon(Icons.check_rounded),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            print(isSwitched);
                          });
                        },
                        // activeTrackColor: Styles.accentColor,
                        activeColor: Styles.accentColor,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                DropdownButtonFormField(
                  focusColor: Styles.accentColor,
                  decoration: InputDecoration.collapsed(
                    hintText: '',
                  ),
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
                const Gap(16),
                TextTimePicker(notifyParent: setTime),
              ],
            ),
          )
        ],
      ),
    );
  }
}
