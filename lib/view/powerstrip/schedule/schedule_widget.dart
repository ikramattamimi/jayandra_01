import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/schedule_controller.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';
import 'package:provider/provider.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key, required this.powerstripSchedule});

  final PowerstripSchedule powerstripSchedule;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
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
                        _deleteScheduleDialogBuilder(context, scheduleProvider);
                      },
                      title: Text(
                        "Hapus Schedule",
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
                        _powerstripSchedule.schedule.time!.to24hours(),
                        style: Styles.headingStyle1,
                      ),
                    ],
                  ),
                  Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: _schedule.socketStatus,
                    onChanged: (value) {
                      setState(() {
                        _schedule.socketStatus = value;
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
                '$socketName $scheduleStatus',
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
  late PowerstripSchedule _powerstripSchedule;
  late PowerstripModel _powerstrip;
  late ScheduleModel _schedule;
  List<String> repeatDay = [];
  late String socketName;
  late String scheduleStatus;
  final _scheduleController = ScheduleController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  @override
  void initState() {
    super.initState();
    _powerstripSchedule = widget.powerstripSchedule;
    _powerstrip = _powerstripSchedule.powerstrip;
    _schedule = _powerstripSchedule.schedule;
    getRepeatDay();
    getSocketName();
  }

  void getRepeatDay() {
    repeatDay = [];
    var repeatAmount = _schedule.days.where((element) => element.isSelected == true).length;
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
    socketName = _powerstrip.sockets.where((socket) => socket.socketNr == _schedule.socketNr).first.name;
    _schedule.socketStatus == true ? scheduleStatus = "Aktif" : scheduleStatus = "Nonaktif";
  }

  Future<void> _deleteScheduleDialogBuilder(BuildContext context, ScheduleProvider scheduleProvider) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Hapus Schedule',
          style: Styles.headingStyle1,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus schedule?',
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
                      _scheduleController.deleteSchedule(_schedule.pwsKey, _schedule.socketNr);
                      deleteSchedule(scheduleProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Schedule berhasil dihapus")),
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

  /// Hapus Schedule
  ///
  /// Memanggil function [deleteSchedule] dari [ScheduleController]
  deleteSchedule(ScheduleProvider scheduleProvider) async {
    // await _scheduleController.deleteSchedule(_schedule.scheduleId!);
    scheduleProvider.removeSchedule(_schedule);
  }
}
