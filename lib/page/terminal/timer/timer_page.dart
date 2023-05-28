import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/timer_controller.dart';
import 'package:jayandra_01/page/terminal/timer/timer_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.terminal});

  final TerminalModel terminal;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TerminalModel? terminal;
  List? timers;

  // Controller untuk model Timer
  final _timerController = TimerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimer();
    terminal = widget.terminal;
  }

  getTimer() async {
    await _timerController.getTimer(1).then((value) {
      setState(() {
        timers = value!.data!;
      });
    });
  }

  Widget getTimerWidget(TimerModel timer) {
    // print('get timer widget');
    var terminalTimer = TerminalTimer(terminal: terminal!, timer: timer);
    return TimerView(
      terminalTimer: terminalTimer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Timer",
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
              context.pushNamed("terminal_timer_add", extra: terminal);
            },
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: timers == null ? [] : timers!.map((timer) => getTimerWidget(timer)).toList(),
      ),
    );
  }
}
