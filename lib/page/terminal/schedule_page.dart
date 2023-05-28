import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/terminal/schedule_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
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
              context.pushNamed("terminal_schedule_add");
            },
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: const [
          ScheduleView(),
        ],
      ),
    );
  }
}
