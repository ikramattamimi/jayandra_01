import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key, required this.terminal});
  final Terminal terminal;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  String pageTitle = "";
  List<String> sockets = ['Socket 1', 'Socket 2', 'Socket 3', 'Socket 4'];

  List<Socket>? socketss;
  Terminal? terminal;

  @override
  void initState() {
    super.initState();
    setTerminal();
    pageTitle = widget.terminal.name;
  }

  void setTerminal() {
    terminal = widget.terminal;
    socketss = terminal?.sockets;
  }

  List<Widget> getSockets() {
    List<Widget> mySockets = [];
    for (var element in socketss!) {
      mySockets.add(
        Expanded(
          child: SocketView(
            id: element.id_socket!,
            isSocketOn: element.status!,
            name: element.name!,
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
            Navigator.pop(context);
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
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WhiteContainer(
              borderColor: Colors.transparent,
              padding: 6,
              margin: 0,
              child: Column(
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    color: Styles.accentColor,
                    size: 32,
                  ),
                  Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getSockets(),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Gap(5),
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    context.goNamed('terminal_schedule');
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
            Column(
              children: [
                const Gap(5),
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => context.goNamed("terminal_timer"),
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
          ],
        ),
      ),
    );
  }
}

class SocketView extends StatefulWidget {
  const SocketView({
    super.key,
    required this.id,
    required this.isSocketOn,
    required this.name,
  });
  final int id;
  final bool isSocketOn;
  final String name;

  @override
  State<SocketView> createState() => _SocketState();
}

class _SocketState extends State<SocketView> {
  bool _isSocketOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSocketOn = widget.isSocketOn;
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
              color: (_isSocketOn != false) ? Styles.accentColor : Styles.accentColor2,
            ),
            onPressed: () {
              setState(() {
                _isSocketOn = !_isSocketOn;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
                widget.name,
                style: Styles.bodyTextBlack3,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit,
            size: 16,
          ),
        )
      ],
    );
  }
}
