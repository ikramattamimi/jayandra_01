import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class MyTimePicker extends StatefulWidget {
  @override
  _MyTimePickerState createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _selectTime(context);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text('Select Time'),
        ),
        SizedBox(height: 16.0),
        Text(
          'Selected Time: ${_selectedTime?.format(context) ?? 'Not set'}',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}

class MySecondTimePicker extends StatefulWidget {
  const MySecondTimePicker({super.key});

  @override
  State<MySecondTimePicker> createState() => _MySecondTimePickerState();
}

class _MySecondTimePickerState extends State<MySecondTimePicker> {
  @override
  final _timePickerTheme = TimePickerThemeData(
    backgroundColor: Colors.blueGrey,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 4),
    ),
    dayPeriodBorderSide: const BorderSide(color: Colors.orange, width: 4),
    dayPeriodColor: Colors.blueGrey.shade600,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 4),
    ),
    dayPeriodTextColor: Colors.white,
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 4),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.orange : Colors.blueGrey.shade800),
    hourMinuteTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.white : Colors.orange),
    dialHandColor: Colors.blueGrey.shade700,
    dialBackgroundColor: Colors.blueGrey.shade800,
    hourMinuteTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    dayPeriodTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    helpTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.orange : Colors.white),
    entryModeIconColor: Colors.orange,
  );
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                // This uses the _timePickerTheme defined above
                timePickerTheme: _timePickerTheme,
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.orange),
                    foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.deepOrange),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
      },
      child: const Text('Click me'),
    );
  }
}

class TimerPickerExample extends StatefulWidget {
  const TimerPickerExample({super.key});

  @override
  State<TimerPickerExample> createState() => _TimerPickerExampleState();
}

class _TimerPickerExampleState extends State<TimerPickerExample> {
  Duration duration = const Duration(hours: 1, minutes: 23);

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts
  // a CupertinoTimerPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _TimerPickerItem(
          children: <Widget>[
            const Text('Timer'),
            ElevatedButton(
              // Display a CupertinoTimerPicker with hour/minute mode.
              onPressed: () => _showDialog(
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: duration,
                  // This is called when the user changes the timer's
                  // duration.
                  onTimerDurationChanged: (Duration newDuration) {
                    setState(() => duration = newDuration);
                  },
                ),
              ),
              // In this example, the timer's value is formatted manually.
              // You can use the intl package to format the value based on
              // the user's locale settings.
              child: Text(
                format(duration),
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// This class simply decorates a row of widgets.
class _TimerPickerItem extends StatelessWidget {
  const _TimerPickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

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
