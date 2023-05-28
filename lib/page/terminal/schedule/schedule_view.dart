import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';
import 'package:jayandra_01/widget/white_container.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key, required this.terminalSchedule});

  final TerminalSchedule terminalSchedule;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        onTap: () => context.pushNamed('terminal_schedule_edit', extra: _terminalSchedule),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        _terminalSchedule.schedule.time!.to24hours(),
                        style: Styles.headingStyle1,
                      ),
                    ],
                  ),
                  Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: _schedule.status,
                    onChanged: (value) {
                      setState(() {
                        _schedule.status = value;
                        // print(timer!.status);
                      });
                    },
                    activeColor: Styles.accentColor,
                  ),
                ],
              ),
              const Gap(4),
              Text(
                repeatDay.join(', '),
                style: Styles.bodyTextGrey2,
              ),
              Text(
                '${socketName} ${scheduleStatus}',
                style: Styles.bodyTextGrey2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  ///
  late TerminalSchedule _terminalSchedule;
  late TerminalModel _terminal;
  late ScheduleModel _schedule;
  List<String> repeatDay = [];
  late String socketName;
  late String scheduleStatus;

  /// ==========================================================================
  /// Local Variable
  /// ==========================================================================
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _terminalSchedule = widget.terminalSchedule;
    _terminal = _terminalSchedule.terminal;
    _schedule = _terminalSchedule.schedule;
    getRepeatDay();
    getSocketName();
  }

  void getRepeatDay() {
    repeatDay = [];
    var repeatAmount = _schedule.days.where((element) => element.isSelected == true).length;
    // print(repeatAmount);
    if (repeatAmount == 7) {
      repeatDay.add("Setiap hari");
      return;
    }
    for (var element in _schedule.days) {
      if (element.isSelected) {
        repeatDay.add(element.name);
      }
    }
  }

  void getSocketName() {
    socketName = _terminal.sockets.where((socket) => socket.id_socket == _schedule.id_socket).first.name!;
    _schedule.status == true ? scheduleStatus = "Aktif" : scheduleStatus = "Nonaktif";
  }
}
