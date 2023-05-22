import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

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
            icon: Icon(Icons.add_rounded),
          )
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          SizedBox(height: 156, width: MediaQuery.of(context).size.width, child: ScheduleView()),
        ],
      ),
    );
  }
}

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      padding: 16,
      margin: 16,
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
                    "22:00",
                    style: Styles.headingStyle1,
                  ),
                  Text(
                    " - ",
                    style: Styles.headingStyle1,
                  ),
                  Text(
                    "02:00",
                    style: Styles.headingStyle1,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.toggle_on,
                  size: 36,
                  color: Styles.accentColor,
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            "Setiap hari",
            style: Styles.bodyTextGrey2,
          ),
          Text(
            "Socket 2",
            style: Styles.bodyTextGrey2,
          ),
        ],
      ),
    );
  }
}
