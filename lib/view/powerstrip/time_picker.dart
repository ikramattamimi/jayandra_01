import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/timeofday_converter.dart';

class MyTimePicker extends StatefulWidget {
  const MyTimePicker({super.key, required this.title, required this.ifPickedTime, required this.currentTime, required this.onTimePicked});

  final String title;
  final bool ifPickedTime;
  final TimeOfDay currentTime;
  final Function(TimeOfDay) onTimePicked;

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  Future selectedTime(BuildContext context, bool ifPickedTime, TimeOfDay initialTime, Function(TimeOfDay) onTimePicked) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        selectedTime(context, widget.ifPickedTime, widget.currentTime, widget.onTimePicked);
      },
      title: Text(
        widget.title,
        style: Styles.bodyTextBlack2,
      ),
      trailing: Text(widget.currentTime.to24hours()),
      contentPadding: EdgeInsets.zero,
    );
  }
}