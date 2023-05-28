import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key, required this.terminal});
  final TerminalModel terminal;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  String pageTitle = "";
  List<String> sockets = ['Socket 1', 'Socket 2', 'Socket 3', 'Socket 4'];
  final _terminalController = TerminalController();

  List<Socket>? socketss;
  TerminalModel? terminal;

  @override
  void initState() {
    super.initState();
    getTerminalState();
    pageTitle = widget.terminal.name;
  }

  void getTerminalState() {
    terminal = widget.terminal;
    socketss = terminal?.sockets;
  }

  void setTerminalByOneSocket() {
    for (var socket in terminal!.sockets) {
      if (socket.status == true) {
        setState(() {
          terminal!.isTerminalActive = true;
        });
        break;
      } else {
        setState(() {
          terminal!.isTerminalActive = false;
        });
      }
    }
  }

  void setTerminal() async {
    setState(() {
      terminal!.isTerminalActive = !terminal!.isTerminalActive;
      for (var socket in socketss!) {
        socket.status = terminal!.isTerminalActive;
      }
    });
    await _terminalController.changeAllSocketStatus(widget.terminal.id, terminal!.isTerminalActive);
  }

  List<Widget> getSockets() {
    List<Widget> mySockets = [];
    for (var element in socketss!) {
      mySockets.add(
        Expanded(
          child: SocketView(
            socket: element,
            changeParentState: setTerminalByOneSocket,
          ),
        ),
      );
    }
    return mySockets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          pageTitle,
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.secondaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pushNamed('main_page');
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Styles.primaryColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
            );
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
      ),
      backgroundColor: Styles.primaryColor,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: WhiteContainer(
                borderColor: Colors.transparent,
                padding: 6,
                margin: 0,
                child: Column(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setTerminal(),
                      icon: Icon(
                        Icons.power_settings_new_rounded,
                        color: terminal!.isTerminalActive ? Styles.accentColor : Styles.accentColor2,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getSockets(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Gap(5),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      context.pushNamed('terminal_schedule');
                    },
                    icon: Icon(
                      Icons.schedule_rounded,
                      color: Styles.accentColor,
                      size: 32,
                    ),
                  ),
                  Text(
                    "Jadwal",
                    style: Styles.bodyTextBlack3,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Gap(5),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => context.pushNamed("terminal_timer", extra: terminal),
                    icon: Icon(
                      Icons.timer,
                      color: Styles.accentColor,
                      size: 32,
                    ),
                  ),
                  Text(
                    "Timer",
                    style: Styles.bodyTextBlack3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final bool _isSocketOn = false;
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
