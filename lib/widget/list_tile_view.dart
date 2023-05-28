import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  final IconData icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Styles.textColor3,
      ),
      title: Text(
        title,
        style: Styles.bodyTextBlack2,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: Styles.textColor3,
      ),
    );
  }
}
