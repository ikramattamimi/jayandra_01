import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/view/report/report_all_widget.dart';
import 'package:jayandra_01/view/report/report_powerstrip_widget.dart';
import 'package:jayandra_01/view/report/report_home_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> with SingleTickerProviderStateMixin {
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
                                    Tab(text: 'Semua'),
                                    Tab(text: 'Rumah'),
                                    Tab(text: 'Powerstrip'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: const [
                                      ReportAllWidget(),
                                      ReportHomeWidget(),
                                      ReportPowerstripWidget(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 0),
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
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
