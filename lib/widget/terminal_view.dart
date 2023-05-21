import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class TerminalView extends StatefulWidget {
  const TerminalView(
      {super.key,
      required this.terminalIcon,
      required this.terminalName,
      required this.activeSocket,
      required this.isTerminalActive});
  final IconData terminalIcon;
  final String terminalName;
  final int activeSocket;
  final bool isTerminalActive;

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  late bool _toggleStatus;
  late IconData _toggleIcon;
  late Color _toggleColor;
  late String _activeSocket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _toggleStatus = widget.isTerminalActive;
    getTogglesStatus();
  }

  void getTogglesStatus() {
    if (_toggleStatus == true) {
      _activeSocket = "${widget.activeSocket} Socket Aktif";
      _toggleStatus = false;
      _toggleIcon = Icons.toggle_on;
      _toggleColor = Styles.accentColor;
    } else {
      _activeSocket = "Nonaktif";
      _toggleStatus = true;
      _toggleIcon = Icons.toggle_off;
      _toggleColor = Styles.textColor3;
    }
  }

  void setToggle() {
    setState(() {
      getTogglesStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = AppLayout.getSize(context);
    return SizedBox(
      width: 170,
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
            // ===================================
            // Icon dan Toggle
            // ===================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.terminalIcon,
                  size: 30,
                ),
                IconButton(
                  onPressed: setToggle,
                  icon: Icon(
                    _toggleIcon,
                    color: _toggleColor,
                    size: 40,
                  ),
                )
              ],
            ),
            // ===================================
            // Nama terminal dan status socket
            // ===================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.terminalName,
                  style: Styles.title,
                ),
                Text(
                  '${_activeSocket}',
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
