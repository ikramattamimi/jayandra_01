import 'package:flutter/material.dart';
import 'package:jayandra_01/models/day_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class DayWidget extends StatefulWidget {
  const DayWidget({super.key, required this.notifyParent, required this.day});

  final DayModel day;
  final Function notifyParent;

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  /// ==========================================================================
  /// Page's Widgets
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: day.isSelected ? Styles.accentColor : Colors.transparent,
          border: Border.all(
            color: day.isSelected ? Colors.transparent : Styles.accentColor,
          )),
      child: TextButton(
        onPressed: () {
          selectDay();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.center,
        ),
        child: Text(
          day.name[0],
          style: day.isSelected ? Styles.bodyTextWhite2 : Styles.buttonTextBlue,
        ),
      ),
    );
  }

  /// ==========================================================================
  /// Variables Init
  /// ==========================================================================

  late DayModel day;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================

  /// State Initialization
  @override
  void initState() {
    super.initState();
    day = widget.day;
  }

  void selectDay() {
    setState(() {
      day.isSelected = !day.isSelected;
      widget.notifyParent(widget.day);
    });
  }
}
