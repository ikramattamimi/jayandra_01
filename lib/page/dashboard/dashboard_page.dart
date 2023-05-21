import 'dart:convert';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:jayandra_01/page/terminal/terminal_page.dart';
import 'package:jayandra_01/screens/report_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/terminal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Widget ini menampilkan halaman Dashboard
class DashboardPage extends StatefulWidget {
  // final User user;
  // const DashboardPage({super.key, required this.user});
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  final _controller = TerminalController();
  List<Terminal>? _terminals = [];
  List<Widget>? _terminalWidgets;

  /// Response pemanggilan API yang sudah dalam bentuk objek [TerminalResponse]
  late TerminalResponse? _terminalObjectResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _getTerminal();
    // print(widget.user);
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  /// Mengambil data terminal
  ///
  /// Jika data terminal berhasil didapat ketika login data akan
  /// diambil dari [SharedPreferences].
  ///
  /// Sebaliknya, data terminal akan diambil dengan melakukan pemanggilan
  /// API getTerminal pada [LoginController]
  void _getTerminal() async {
    try {
      _terminalObjectResponse = await _controller.getTerminal();
      _terminals = _terminalObjectResponse?.data;
    } catch (e) {
      print(e);
    }

    _getTerminalWidget();
  }

  void _getTerminalWidget() {
    if (_terminals != null) {
      for (var terminal in _terminals!) {
        _terminalWidgets = [];
        _terminalWidgets!.add(
          GestureDetector(
            onTap: () {
              print("Perangkat ditekan");
              context.goNamed('terminal', extra: terminal);
            },
            child: TerminalView(
              terminalIcon: Icons.bed,
              terminalName: terminal.name,
              activeSocket: terminal.totalActiveSocket,
              isTerminalActive: terminal.isTerminalActive,
            ),
          ),
        );
      }
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
              children: _terminalWidgets ??
                  [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Belum ada perangkat",
                          style: Styles.bodyTextBlack,
                        ),
                      ),
                    ),
                  ],
            ),
          )
        ],
      ),
    );
  }
}
