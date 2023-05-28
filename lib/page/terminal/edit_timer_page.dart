import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/timer_controller.dart';
import 'package:jayandra_01/page/terminal/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

class EditTimerPage extends StatefulWidget {
  const EditTimerPage({super.key, required this.terminalTimer});
  final TerminalTimer terminalTimer;

  @override
  State<EditTimerPage> createState() => _EditTimerPageState();
}

class _EditTimerPageState extends State<EditTimerPage> {
  /// ==========================================================================
  /// Widget Page
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Edit Timer",
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
            onPressed: () {},
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
                          value: isTimerActive,
                          onChanged: (value) {
                            setState(() {
                              isTimerActive = value;
                              timerStatus = isTimerActive ? "Aktif" : "Nonaktif";
                              print(isTimerActive);
                            });
                          },
                          // activeTrackColor: Styles.accentColor,
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
                  currentTime: socketOffTime,
                  onTimePicked: (x) {
                    setState(() {
                      socketOffTime = x;
                      print("The picked time is: $x");
                    });
                  },
                ),
                ListTile(
                  onTap: () {
                    _deleteTimerDialogBuilder(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Hapus Timer",
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ==========================================================================
  /// Deklarasi Variabel
  /// ==========================================================================
  /// Waktu socket dinonaktifkan
  late TimeOfDay socketOffTime;

  /// Value [DropdownMenuItem] yang dipilih
  String selectedValue = "";

  /// Apakah timer aktif atau tidak
  late bool isTimerActive;
  var timerStatus = "Aktif";

  /// Model Terminal untuk nanti update timer
  ///
  /// update Timer belum ada API nya
  /// API baru bisa hapus timer
  TerminalModel? terminal;

  /// Model Timer yang akan di update
  TimerModel? timer;

  /// Controller untuk API Timer
  final _timerController = TimerController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// Initial State
  @override
  void initState() {
    super.initState();
    // inisiasi terminal dan timer
    terminal = widget.terminalTimer.terminal;
    timer = widget.terminalTimer.timer;

    // Inisialisasi Timer
    isTimerActive = timer!.status;
    socketOffTime = timer!.time!;
    selectedValue = timer!.id_socket.toString();
  }

  /// Update Timer
  ///
  /// TODO: ganti fungsi jadi update timer
  addTimer() async {
    TimerModel timer = TimerModel(
      id_socket: int.parse(selectedValue),
      time: socketOffTime,
      status: isTimerActive,
    );
    await _timerController.addTimer(timer);
    // print(addTimerResponse);
  }

  /// Hapus Timer
  ///
  /// Memanggil function [deleteTimer] dari [TimerController]
  deleteTimer() async {
    await _timerController.deleteTimer(timer!.id_timer!).then((value) => print(value!.message));
  }

  /// Menampilkan dialog konfirmasi hapus timer
  Future<void> _deleteTimerDialogBuilder(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Log Out',
          style: Styles.headingStyle1,
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: Styles.bodyTextBlack,
        ),
        actions: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    deleteTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.red.shade400,
                    minimumSize: const Size(50, 50),
                  ),
                  child: Text(
                    "Oke".toUpperCase(),
                    style: Styles.buttonTextWhite,
                  ),
                ),
                const Gap(8),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Batalkan'),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(50, 50),
                  ),
                  child: Text(
                    'Batal'.toUpperCase(),
                    style: Styles.buttonTextBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Inisiasi Menu Dropdown pemilihan Socket
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
}
