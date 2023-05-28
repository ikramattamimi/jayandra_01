import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SocketView extends StatefulWidget {
  const SocketView({
    super.key,
    required this.socket,
    required this.changeParentState,
  });
  final Socket socket;
  final Function() changeParentState;

  @override
  State<SocketView> createState() => _SocketState();
}

class _SocketState extends State<SocketView> {
  late Socket socket;
  final TerminalController _terminalController = TerminalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
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
              color: (socket.status != false) ? Styles.accentColor : Styles.accentColor2,
            ),
            onPressed: () {
              setState(() {
                socket.status = socket.status != null ? !socket.status! : true;
                widget.changeParentState();
              });
              _terminalController.updateSocket(socket);
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
                socket.name!,
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
