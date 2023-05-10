import 'package:carbon_icons/carbon_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/screens/report_view.dart';
import 'package:jayandra_01/widget/terminal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
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
                      "Halo $userName!",
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
              children: [
                GestureDetector(
                  onTap: () {
                    print("Perangkat ditekan");
                    context.goNamed("terminal_1");
                  },
                  child: TerminalView(
                    terminalIcon: Icons.bed,
                    terminalName: "Kamar Adik",
                    activeSocket: 3,
                    terminalStatus: true,
                  ),
                ),
                TerminalView(
                  terminalIcon: Icons.soup_kitchen_rounded,
                  terminalName: "Dapur",
                  activeSocket: 3,
                  terminalStatus: false,
                ),
                TerminalView(
                  terminalIcon: Icons.family_restroom_rounded,
                  terminalName: "Ruang Keluarga",
                  activeSocket: 3,
                  terminalStatus: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
