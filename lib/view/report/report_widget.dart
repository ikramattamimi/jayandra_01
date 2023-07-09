import 'package:gap/gap.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final userProvider = Provider.of<UserModel>(context);

    final reportDashboard = reportProvider.reportDashboard;
    var total = 0.0;
    for (var report in reportDashboard) {
      total += report.usage;
    }
    final size = AppLayout.getSize(context);
    return SizedBox(
      width: size.width,
      height: 200.0,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.accentColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LAPORAN PENGGUNAAN",
                  style: Styles.bodyTextWhite,
                ),
                IconButton(
                  onPressed: () {
                    reportProvider.createReportDashboardModelsFromApi(userProvider.email);
                  },
                  icon: const Icon(
                    Icons.replay_circle_filled_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat.currency(
                      symbol: "Rp ",
                      decimalDigits: 2,
                    ).format(total),
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "Digunakan hari ini",
                    style: Styles.bodyTextWhite3,
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
