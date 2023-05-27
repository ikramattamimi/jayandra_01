import 'package:flutter/material.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key, this.timer});

  final TimerModel? timer;

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late TimerModel? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.timer != null ? timer = widget.timer : null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        color: Styles.secondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        timer!.time!.to24hours(),
                        // "03:00",
                        style: Styles.headingStyle1,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      timer!.status == true ? Icons.toggle_on : Icons.toggle_off,
                      size: 36,
                      color: Styles.accentColor,
                    ),
                  ),
                ],
              ),
              // const Gap(4),
              Text(
                timer!.id_socket.toString(),
                style: Styles.bodyTextGrey2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
