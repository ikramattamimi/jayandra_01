import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/timer_controller.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';
import 'package:provider/provider.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key, required this.terminalTimer});

  final TerminalTimer terminalTimer;

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late TimerModel? timer;
  late TerminalModel? terminal;
  late TerminalTimer? terminalTimer;
  late String socketName;
  final _timerController = TimerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    terminalTimer = widget.terminalTimer;
    timer = terminalTimer!.timer;
    terminal = terminalTimer!.terminal;
    socketName = terminal!.sockets!.firstWhere((element) => element.socketId! == timer!.socketId).name!;
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        color: Styles.secondaryColor,
        child: InkWell(
          // onTap: () => context.pushNamed('terminal_timer_edit', extra: terminalTimer),
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          _deleteTimerDialogBuilder(context, timerProvider);
                        },
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
                      ),
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      timer!.time!.to24hours(),
                      style: Styles.headingStyle1,
                    ),
                    SizedBox(
                      width: 40,
                      height: 25,
                      child: Switch(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: timer!.status,
                        onChanged: (value) {
                          setState(() {
                            timer!.status = value;
                            timerProvider.changeTimerStatus(timer!.timerId!, timer!.status);
                          });
                        },
                        activeColor: Styles.accentColor,
                      ),
                    ),
                  ],
                ),
                // const Gap(4),
                Text(
                  socketName,
                  style: Styles.bodyTextGrey2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              padding: EdgeInsets.symmetric(horizontal: 16),
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

  /// Hapus Timer
  ///
  /// Memanggil function [deleteTimer] dari [TimerController]
  deleteTimer(TimerProvider timerProvider) async {
    await _timerController.deleteTimer(timer!.timerId!).then((value) => print(value!.message));
    timerProvider.removeTimer(timer!.timerId!);
  }
}
