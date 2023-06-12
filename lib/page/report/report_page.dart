import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/page/report/budgeting/budgeting_view.dart';
import 'package:jayandra_01/page/report/home_report_view.dart';
import 'package:jayandra_01/page/report/socket_report_view.dart.dart';
import 'package:jayandra_01/page/report/terminal_report_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Laporan Penggunaan",
                  style: Styles.headingStyle1,
                ),
                const Gap(32),
                Card(
                  // elevation: 0,
                  child: SizedBox(
                    height: 430,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  labelColor: Styles.accentColor,
                                  dividerColor: Styles.accentColor,
                                  indicatorColor: Styles.accentColor,
                                  unselectedLabelColor: Styles.accentColor2,
                                  tabs: const [
                                    Tab(text: 'Rumah'),
                                    Tab(text: 'Terminal'),
                                    Tab(text: 'Socket'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      HomeReportView(),
                                      TerminalReportView(),
                                      SocketReportView(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 0),
                        const BudgetingView(progress: 0.5),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
