import 'dart:convert';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/page/terminal/terminal_page.dart';
import 'package:jayandra_01/screens/report_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/terminal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  final _controller = TerminalController();
  List? _terminals = [];
  List<Widget> _terminalWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _getTerminal();
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  void _getTerminal() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('terminal') != null) {
      String? jsonString = prefs.getString('terminal');
      Map<String, dynamic> myBody = jsonDecode(jsonString.toString());

      MyArrayResponse<Terminal> response = MyArrayResponse.fromJsonArray(myBody, Terminal.fromJson);
      _terminals = response.data;
    } else {
      try {
        String? jsonString = await _controller.getTerminal();
        Map<String, dynamic> myBody = jsonDecode(jsonString.toString());

        MyArrayResponse<Terminal> response = MyArrayResponse.fromJsonArray(myBody, Terminal.fromJson);

        _terminals = response.data;
      } catch (e) {
        print(e);
      }
    }

    for (var terminal in _terminals!) {
      _terminalWidgets.add(
        GestureDetector(
          onTap: () {
            print("Perangkat ditekan");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TerminalPage(
                terminal: terminal,
              );
            }));
          },
          child: TerminalView(
            terminalIcon: Icons.bed,
            terminalName: terminal.name,
            activeSocket: 0,
            terminalStatus: false,
          ),
        ),
      );
    }
  }

  void _getTerminalWidget() {
    for (var terminal in _terminals!) {
      _terminalWidgets.add(
        GestureDetector(
          onTap: () {
            print("Perangkat ditekan");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TerminalPage(
                terminal: terminal,
              );
            }));
          },
          child: TerminalView(
            terminalIcon: Icons.bed,
            terminalName: terminal.name,
            activeSocket: 0,
            terminalStatus: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (userName != null) ? "Halo $userName!" : "Halo",
                      style: Styles.headingStyle1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: null,
                          icon: Icon(
                            Icons.notifications_rounded,
                            size: 30,
                            color: Styles.textColor3,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context.goNamed('add_device'),
                          icon: Icon(
                            CarbonIcons.add_filled,
                            size: 30,
                            color: Styles.accentColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Gap(16),
                // ============== Laporan Penggunaan
                ReportView(),
              ],
            ),
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Perangkat Anda",
              style: Styles.headingStyle2,
              textAlign: TextAlign.start,
            ),
          ),
          const Gap(24),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _terminalWidgets,
              )
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         print("Perangkat ditekan");
              //         context.goNamed("terminal_1");
              //       },
              //       child: TerminalView(
              //         terminalIcon: Icons.bed,
              //         terminalName: "Kamar Adik",
              //         activeSocket: 3,
              //         terminalStatus: true,
              //       ),
              //     ),
              //     TerminalView(
              //       terminalIcon: Icons.soup_kitchen_rounded,
              //       terminalName: "Dapur",
              //       activeSocket: 3,
              //       terminalStatus: false,
              //     ),
              //     TerminalView(
              //       terminalIcon: Icons.family_restroom_rounded,
              //       terminalName: "Ruang Keluarga",
              //       activeSocket: 3,
              //       terminalStatus: true,
              //     ),
              //   ],
              // ),
              )
        ],
      ),
    );
  }
}
