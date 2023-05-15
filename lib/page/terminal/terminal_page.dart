import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    pageTitle = widget.terminal.name;
  }

  List<Widget> getSockets() {
    List<Widget> mySockets = <Socket>[];
    for (var element in sockets) {
      mySockets.add(Socket(
        id: 1,
        isSocketOn: false,
        name: element,
      ));
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
                  // Socket(id: 1, status: status, name: name),
                  // getSockets(),

                  Expanded(
                    child: Socket(
                      id: 1,
                      isSocketOn: true,
                      name: sockets[0],
                    ),
                  ),
                  Expanded(
                    child: Socket(
                      id: 1,
                      isSocketOn: true,
                      name: sockets[1],
                    ),
                  ),
                  Expanded(
                    child: Socket(
                      id: 1,
                      isSocketOn: true,
                      name: sockets[2],
                    ),
                  ),
                  Expanded(
                    child: Socket(
                      id: 1,
                      isSocketOn: true,
                      name: sockets[3],
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

class Socket extends StatefulWidget {
  const Socket({
    super.key,
    required this.id,
    required this.isSocketOn,
    required this.name,
  });
  final int id;
  final bool isSocketOn;
  final String name;

  @override
  State<Socket> createState() => _SocketState();
}

class _SocketState extends State<Socket> {
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
        const Gap(16),
        Text(
          "Socket 1",
          style: Styles.bodyTextBlack3,
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
