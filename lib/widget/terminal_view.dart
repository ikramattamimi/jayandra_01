import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class TerminalView extends StatefulWidget {
  const TerminalView({super.key, required this.terminal, required this.terminalIcon});
  final Terminal terminal;
  final IconData terminalIcon;

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  late bool _toggleStatus;
  late IconData _toggleIcon;
  late Color _toggleColor;
  late String _activeSocket;
  late int _totalActiveSocket;
  late Terminal terminal;

  final _terminalController = TerminalController();
  late TerminalResponse? _terminalObjectResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _toggleStatus = widget.terminal.isTerminalActive;
    _totalActiveSocket = widget.terminal.totalActiveSocket;
    getTogglesStatus();
  }

  void getTogglesStatus() {
    if (_toggleStatus == true) {
      _activeSocket = "$_totalActiveSocket Socket Aktif";
      _toggleIcon = Icons.toggle_on;
      _toggleColor = Styles.accentColor;
    } else {
      _activeSocket = "Nonaktif";
      _toggleIcon = Icons.toggle_off;
      _toggleColor = Styles.textColor3;
    }
  }

  void setToggle() async {
    _toggleStatus = !_toggleStatus;
    // _totalActiveSocket = 4;
    _terminalObjectResponse = await _terminalController.changeAllSocketStatus(widget.terminal.id, _toggleStatus);
    setState(() {
      getTogglesStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = AppLayout.getSize(context);
    return GestureDetector(
      onTap: () {
        print("Perangkat ditekan");
        context.goNamed('terminal', extra: widget.terminal);
      },
      child: SizedBox(
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
                  // IconButton(
                  //   onPressed: setToggle,
                  //   icon:
                  Icon(
                    _toggleIcon,
                    color: _toggleColor,
                    size: 40,
                  ),
                  // )
                ],
              ),
              // ===================================
              // Nama terminal dan status socket
              // ===================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.terminal.name,
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
      ),
    );
  }
}
