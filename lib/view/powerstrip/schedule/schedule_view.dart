import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/schedule_model.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/schedule_controller.dart';
import 'package:jayandra_01/view/powerstrip/schedule/schedule_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key, required this.powerstrip});

  final PowerstripModel powerstrip;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final schedulesfromprovider = scheduleProvider.schedules.where((element) => element.powerstripId == powerstrip.id);
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
                context.pushNamed("powerstrip_schedule_add", extra: powerstrip);
              },
              icon: const Icon(Icons.add_rounded),
            )
          ],
        ),
        backgroundColor: Styles.primaryColor,
        body: ListView.builder(
          itemCount: schedulesfromprovider.length,
          itemBuilder: (context, index) {
            final scheduleModel = schedulesfromprovider.elementAt(index);
            return ScheduleWidget(powerstripSchedule: PowerstripSchedule(powerstrip: powerstrip, schedule: scheduleModel));
          },
        ));
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================

  late PowerstripModel powerstrip;
  final _scheduleController = ScheduleController();
  // List? _schedules;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// State Init
  @override
  void initState() {
    super.initState();
    powerstrip = widget.powerstrip;
    // getSchedule();
  }

  /// get Schedule
  getSchedule() async {
    await _scheduleController.getSchedule(powerstrip.id).then((value) {
      setState(() {});
    });
  }

  /// Get Schedule Widget
  Widget getScheduleWidget(ScheduleModel schedule) {
    var powerstripSchedule = PowerstripSchedule(powerstrip: powerstrip, schedule: schedule);
    return ScheduleWidget(
      powerstripSchedule: powerstripSchedule,
    );
  }
}
