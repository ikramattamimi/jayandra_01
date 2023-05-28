
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

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