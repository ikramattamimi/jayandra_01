import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
    super.key,
    required this.borderColor,
    required this.padding,
    required this.child,
    required this.margin,
  });
  final Color borderColor;
  final double margin;
  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          color: Styles.secondaryColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
