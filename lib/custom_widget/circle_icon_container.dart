import 'package:flutter/material.dart';

class CircleIconContainer extends StatelessWidget {
  const CircleIconContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.icon,
      required this.iconSize,
      required this.iconColor});
  final double width;
  final double height;
  final Color color;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
