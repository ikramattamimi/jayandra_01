import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/module/terminal/terminal_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SocketView extends StatefulWidget {
  const SocketView({
    super.key,
    required this.socketId,
    required this.terminalId,
    // required this.socket,
    required this.changeParentState,
  });
  // final SocketModel socket;
  final Function changeParentState;
  final int socketId;
  final int terminalId;

  @override
  State<SocketView> createState() => _SocketState();
}

class _SocketState extends State<SocketView> {
  // late SocketModel socket;
  final TerminalController _terminalController = TerminalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);

    // initWidgets(userModel, terminalProvider);
    var terminal = terminalProvider.terminals.firstWhere((element) => element.id == widget.terminalId);
    var mySocket = terminal.sockets!.firstWhere((element) => element.socketId == widget.socketId);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 85,
          width: 85,
          child: IconButton(
            icon: Icon(
              MdiIcons.powerSocketDe,
              size: 85,
              color: (mySocket.status != false) ? Styles.accentColor : Styles.accentColor2,
            ),
            onPressed: () {
              setState(() {
                mySocket.status = !mySocket.status!;
                terminal.updateOneSocketStatus(mySocket.socketId!, mySocket.status!);
                widget.changeParentState(terminal);
              });
              _terminalController.updateSocket(mySocket);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const Gap(10),
        SizedBox(
          width: 67,
          child: Wrap(
            children: [
              Text(
                mySocket.name!,
                style: Styles.bodyTextBlack3,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.edit,
            size: 16,
          ),
        )
      ],
    );
  }
}
