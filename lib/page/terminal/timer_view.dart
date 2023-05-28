import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = widget.terminalTimer.timer;
    terminal = widget.terminalTimer.terminal;
    terminalTimer = TerminalTimer(terminal: terminal!, timer: timer!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('terminal_timer_edit', extra: terminalTimer);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          color: Styles.secondaryColor,
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
                            // print(timer!.status);
                          });
                        },
                        activeColor: Styles.accentColor,
                      ),
                    ),
                  ],
                ),
                // const Gap(4),
                Text(
                  timer!.id_socket.toString(),
                  style: Styles.bodyTextGrey2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
