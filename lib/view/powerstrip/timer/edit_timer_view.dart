import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/powerstrip/timer_controller.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/view/powerstrip/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';
import 'package:provider/provider.dart';

class EditTimerView extends StatefulWidget {
  const EditTimerView({
    super.key,
    required this.powerstripTimer,
    this.notifyParent,
  });
  final PowerstripTimer powerstripTimer;
  final Function? notifyParent;

  @override
  State<EditTimerView> createState() => _EditTimerViewState();
}

class _EditTimerViewState extends State<EditTimerView> {
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
          "Edit Timer",
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
                  currentTime: socketOffTime,
                  onTimePicked: (x) {
                    setState(() {
                      socketOffTime = x;
                    });
                  },
                ),
                ListTile(
                  onTap: () {
                    _deleteTimerDialogBuilder(context, timerProvider);
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

  /// Model Powerstrip untuk nanti update timer
  ///
  /// update Timer belum ada API nya
  /// API baru bisa hapus timer
  PowerstripModel? powerstrip;

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
    // inisiasi powerstrip dan timer
    powerstrip = widget.powerstripTimer.powerstrip;
    timer = widget.powerstripTimer.timer;

    // Inisialisasi Timer
    isTimerActive = timer!.status;
    socketOffTime = timer!.time!;
    selectedValue = timer!.socketId.toString();
  }

  /// Update Timer
  ///
  /// TODO: ganti fungsi jadi update timer
  addTimer() async {
    TimerModel timer = TimerModel(
      socketId: int.parse(selectedValue),
      time: socketOffTime,
      status: isTimerActive,
    );
    await _timerController.addTimer(timer);
  }

  /// Hapus Timer
  ///
  /// Memanggil function [deleteTimer] dari [TimerController]
  deleteTimer(TimerProvider timerProvider) async {
    await _timerController.deleteTimer(timer!.timerId!);
    timerProvider.removeTimer(timer!.timerId!);
  }

  /// Menampilkan dialog konfirmasi hapus timer
  Future<void> _deleteTimerDialogBuilder(BuildContext context, TimerProvider timerProvider) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Hapus Timer',
          style: Styles.headingStyle1,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus timer?',
          style: Styles.bodyTextBlack,
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      deleteTimer(timerProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Timer berhasil dihapus")),
                      );
                      context.pop();
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red.shade400,
                        minimumSize: const Size(50, 50),
                        padding: EdgeInsets.zero),
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
                      style: Styles.bodyTextGrey2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Inisiasi Menu Dropdown pemilihan Socket
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var socket in powerstrip!.sockets!) {
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
}
