import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/timer_controller.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/page/terminal/timer/timer_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    super.key,
    required this.terminal,
  });

  final TerminalModel terminal;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final timersfromprovider = timerProvider.timers.where((element) => element.terminalId == terminal.id);

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
      // body: ListView(
      // children: timers == null ? [] : timers!.map((timer) => getTimerWidget(timer)).toList(),
      // ),
      body: ListView.builder(
        itemCount: timersfromprovider.length,
        itemBuilder: (context, index) {
          final timerModel = timersfromprovider.elementAt(index);
          return TimerView(terminalTimer: TerminalTimer(terminal: terminal, timer: timerModel));
        },
      ),
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  late TerminalModel terminal;
  List? timers;

  // late TimerProvider timerProvider;
  // late List<TimerModel> timersfromprovider;

  // Controller untuk model Timer
  final _timerController = TimerController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================

  /// State Init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    terminal = widget.terminal;
    getTimer();
  }

  /// Get Timer data from API
  getTimer() async {
    await _timerController.getTimer(terminal.id).then((value) {
      setState(() {
        timers = value!.data!;
      });
    });
  }

  /// Get Timer widget by data from [getTimer]
  Widget getTimerWidget(TimerModel timer) {
    // print('get timer widget');
    var terminalTimer = TerminalTimer(terminal: terminal, timer: timer);
    return TimerView(
      terminalTimer: terminalTimer,
    );
  }
}
