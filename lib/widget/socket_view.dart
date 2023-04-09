import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class SocketView extends StatelessWidget {
  const SocketView(
      {super.key,
      required this.socketIcon,
      required this.socketName,
      required this.status,
      required this.activeSocket});
  final IconData socketIcon;
  final String socketName;
  final bool status;
  final int activeSocket;

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return SizedBox(
      width: size.width / 2.2,
      height: 140,
      child: Container(
        margin: const EdgeInsets.only(
          left: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Styles.secondaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  socketIcon,
                  size: 30,
                ),
                SocketTogleIcon()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  socketName,
                  style: Styles.title,
                ),
                Text(
                  'Socket Aktif',
                  style: Styles.bodyTextGrey3,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SocketTogleIcon extends StatefulWidget {
  const SocketTogleIcon({super.key});

  @override
  State<SocketTogleIcon> createState() => _SocketTogleIconState();
}

class _SocketTogleIconState extends State<SocketTogleIcon> {
  bool status = false;
  IconData icon = Icons.toggle_off;
  Color color = Styles.textColor3;

  void setToggle() {
    setState(() {
      if (status == true) {
        status = false;
        icon = Icons.toggle_on;
        color = Styles.accentColor;
      } else {
        status = true;
        icon = Icons.toggle_off;
        color = Styles.textColor3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: setToggle,
      icon: Icon(
        icon,
        color: color,
        size: 40,
      ),
    );
  }
}
