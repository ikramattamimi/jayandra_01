import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/module/terminal/terminal_provider.dart';
import 'package:jayandra_01/page/terminal/socket_view.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({
    super.key,
    required this.idTerminal,
    // required this.terminal,
  });
  // final TerminalModel terminal;
  final int idTerminal;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);

    // initWidgets(userModel, terminalProvider);
    var myTerminal = terminalProvider.terminals.firstWhere((element) => element.id == widget.idTerminal);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myTerminal.name,
              style: Styles.pageTitle,
            ),
            IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Ganti nama terminal',
                      style: Styles.headingStyle1,
                    ),
                    content: Text(
                      'Masukkan nama terminal yang baru',
                      style: Styles.bodyTextBlack,
                    ),
                    actions: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextFormField(
                                controller: _updateNameController,
                                prefixIcon: MdiIcons.powerSocketDe,
                                hintText: terminal!.name,
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                // onSaved:
                              ),
                              const Gap(16),
                              ElevatedButton(
                                onPressed: () {
                                  // deleteTimer(timerProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Nama socket diganti")),
                                  );
                                  terminalProvider.updateTerminalName(
                                    _updateNameController.text,
                                    terminal!.id,
                                  );
                                  context.pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Styles.accentColor,
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  "simpan".toUpperCase(),
                                  style: Styles.buttonTextWhite,
                                ),
                              ),
                              const Gap(8),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Batalkan'),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(50, 50),
                                ),
                                child: Text(
                                  'Batal'.toUpperCase(),
                                  style: Styles.bodyTextGrey2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Styles.secondaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 5,
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setTerminal(myTerminal),
                      icon: Icon(
                        Icons.power_settings_new_rounded,
                        color: myTerminal.isTerminalActive ? Styles.accentColor : Styles.accentColor2,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getSockets(myTerminal.sockets!),
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
                      context.pushNamed('terminal_schedule', extra: terminal);
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

  /// ==========================================================================
  /// Data Dictionary
  /// ==========================================================================
  String pageTitle = "";
  List<String> sockets = ['Socket 1', 'Socket 2', 'Socket 3', 'Socket 4'];
  final _terminalController = TerminalController();
  final TextEditingController _updateNameController = TextEditingController();

  List<SocketModel>? socketss;
  TerminalModel? terminal;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  @override
  void initState() {
    super.initState();
    getTerminalState();

    BuildContext myContext = context;
    final terminalProvider = Provider.of<TerminalProvider>(myContext, listen: false);
    terminal = terminalProvider.terminals.firstWhere((element) => element.id == widget.idTerminal);
    // pageTitle = widget.terminal.name;
  }

  void getTerminalState() {
    // terminal = widget.terminal;
    // socketss = terminal?.sockets;
  }

  updateTerminalStatusByOneSocketChange(TerminalModel terminal) {
    for (var socket in terminal.sockets!) {
      if (socket.status == true) {
        setState(() {
          terminal.isTerminalActive = true;
        });
        break;
      } else {
        setState(() {
          terminal.isTerminalActive = false;
        });
      }
    }
  }

  void setTerminal(TerminalModel myTerminal) async {
    setState(() {
      myTerminal.isTerminalActive = !myTerminal.isTerminalActive;
      for (var socket in myTerminal.sockets!) {
        socket.status = myTerminal.isTerminalActive;
      }
    });
    myTerminal.updateAllSocketStatus(myTerminal.isTerminalActive);
    await _terminalController.changeAllSocketStatus(myTerminal.id, myTerminal.isTerminalActive);
  }

  List<Widget> getSockets(List<SocketModel> mySockets) {
    List<Widget> socketWidgets = [];
    for (var element in mySockets) {
      socketWidgets.add(
        Container(
          constraints: BoxConstraints(minHeight: AppLayout.getSize(context).height / 5.5),
          child: SocketView(
            socketId: element.socketId!,
            terminalId: element.terminalId!,
            changeParentState: updateTerminalStatusByOneSocketChange,
          ),
        ),
      );
    }
    return socketWidgets;
  }
}
