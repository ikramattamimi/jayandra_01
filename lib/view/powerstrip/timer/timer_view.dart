import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/powerstrip/timer_controller.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/view/powerstrip/timer/timer_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class TimerView extends StatefulWidget {
  const TimerView({
    super.key,
    required this.powerstrip,
  });

  final PowerstripModel powerstrip;

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final timersfromprovider = timerProvider.timers.where((element) => element.pwsKey == powerstrip.pwsKey);
    // Logger().i(powerstrip.pwsKey);

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
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.pushNamed("powerstrip_timer_add", extra: powerstrip);
        //     },
        //     icon: const Icon(Icons.add_rounded),
        //   )
        // ],
      ),
      backgroundColor: Styles.primaryColor,
      // body: ListView(
      // children: timers == null ? [] : timers!.map((timer) => getTimerWidget(timer)).toList(),
      // ),
      body: ListView.builder(
        itemCount: timersfromprovider.length,
        itemBuilder: (context, index) {
          final timerModel = timersfromprovider.elementAt(index);
          // Logger().i(powerstrip, timerModel);
          return TimerWidget(powerstripTimer: PowerstripTimer(powerstrip: powerstrip, timer: timerModel));
        },
      ),
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  late PowerstripModel powerstrip;
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
    super.initState();
    powerstrip = widget.powerstrip;
    getTimer();
  }

  updateState() {
    setState(() {});
  }

  /// Get Timer data from API
  getTimer() async {
    await _timerController.getTimer(powerstrip.pwsKey).then((value) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value!.message)));
      // Logger().i(value.data);
      setState(() {
        timers = value!.data!;
      });
    });
  }

  /// Get Timer widget by data from [getTimer]
  Widget getTimerWidget(TimerModel timer) {
    var powerstripTimer = PowerstripTimer(powerstrip: powerstrip, timer: timer);
    return TimerWidget(
      powerstripTimer: powerstripTimer,
    );
  }
}
