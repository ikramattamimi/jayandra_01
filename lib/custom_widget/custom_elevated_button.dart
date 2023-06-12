import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textStyle,
    required this.onPressed,
  });
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final TextStyle textStyle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: backgroundColor,
        minimumSize: const Size(50, 50),
        side: BorderSide(color: borderColor),
      ),
      child: Text(
        text.toUpperCase(),
        style: textStyle,
      ),
    );
  }
}
