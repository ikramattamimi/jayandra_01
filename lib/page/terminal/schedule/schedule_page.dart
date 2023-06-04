import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/terminal/schedule_controller.dart';
import 'package:jayandra_01/page/terminal/schedule/schedule_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.terminal});

  final TerminalModel terminal;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final schedulesfromprovider = scheduleProvider.schedules.where((element) => element.terminalId == terminal.id);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            "Jadwal",
            style: Styles.pageTitle,
          ),
          backgroundColor: Styles.secondaryColor,
          centerTitle: true,
          foregroundColor: Styles.textColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
                context.pushNamed("terminal_schedule_add", extra: terminal);
              },
              icon: const Icon(Icons.add_rounded),
            )
          ],
        ),
        backgroundColor: Styles.primaryColor,
        // body: ListView(
        //   children: _schedules == null ? [] : _schedules!.map((schedule) => getScheduleWidget(schedule)).toList()
        //     ..add(const Gap(16)),
        // ),
        body: ListView.builder(
          itemCount: schedulesfromprovider.length,
          itemBuilder: (context, index) {
            final scheduleModel = schedulesfromprovider.elementAt(index);
            print(schedulesfromprovider.length);
            return ScheduleView(terminalSchedule: TerminalSchedule(terminal: terminal, schedule: scheduleModel));
          },
        ));
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================

  late TerminalModel terminal;
  final _scheduleController = ScheduleController();
  // List? _schedules;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// State Init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    terminal = widget.terminal;
    // getSchedule();
  }

  /// get Schedule
  getSchedule() async {
    await _scheduleController.getSchedule(terminal.id).then((value) {
      setState(() {
        // _schedules = value!.data!;
        // print(_schedules);
      });
    });
  }

  /// Get Schedule Widget
  Widget getScheduleWidget(ScheduleModel schedule) {
    // print('get schedule widget');
    var terminalSchedule = TerminalSchedule(terminal: terminal, schedule: schedule);
    return ScheduleView(
      terminalSchedule: terminalSchedule,
    );
  }
}
