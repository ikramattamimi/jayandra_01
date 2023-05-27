import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class TextTimePicker extends StatefulWidget {
  final Function notifyParent;

  const TextTimePicker({super.key, required this.notifyParent});

  @override
  _TextTimePickerState createState() => _TextTimePickerState();
}

class _TextTimePickerState extends State<TextTimePicker> {
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: formatTime(selectedTime));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTimePickerDialog(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
            labelText: 'Waktu',
            labelStyle: Styles.bodyTextBlack,
            suffixIcon: Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        // print(selectedTime.hour);
        widget.notifyParent(selectedTime.hour, selectedTime.minute);
        _textEditingController.text = formatTime(selectedTime);
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final formattedTime = DateFormat('HH:mm').format(DateTime(0, 0, 0, time.hour, time.minute));
    return formattedTime;
  }
}
