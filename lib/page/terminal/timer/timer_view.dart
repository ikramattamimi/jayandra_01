import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
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
    // final timers = timerProvider.timers.wh;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        color: Styles.secondaryColor,
        child: InkWell(
          onTap: () => context.pushNamed('terminal_timer_edit', extra: terminalTimer),
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
}
