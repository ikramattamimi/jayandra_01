import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  const CustomRadio({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
  });
  final String title;
  final String value;
  final String? groupValue;

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  String? groupValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupValue = widget.groupValue;
  }

  void selectRadio(value) {
    setState(() {
      groupValue = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(widget.title),
      value: widget.value,
      groupValue: groupValue,
      onChanged: (value) {
        selectRadio(value);
      },
    );
  }
}
