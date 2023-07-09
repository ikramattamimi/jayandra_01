import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportAllWidget extends StatefulWidget {
  const ReportAllWidget({super.key});

  @override
  State<ReportAllWidget> createState() => _ReportAllWidgetState();
}

class _ReportAllWidgetState extends State<ReportAllWidget> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final pwsProvider = Provider.of<PowerstripProvider>(context);

    final reportAll = reportProvider.reportAll;
    var total = 0.0;
    for (var report in reportAll) {
      total += report.usage;
    }
    return Column(
      children: [
        const Gap(20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.currency(
                      symbol: "Rp ",
                      decimalDigits: 2,
                    ).format(total),
                    style: Styles.headingStyle3,
                  ),
                  Text(
                    "Biaya digunakan bulan ini",
                    style: Styles.bodyTextGrey3,
                  )
                ],
              ),
            ],
          ),
        ),
        const Gap(10),
        SizedBox(
          height: 200,
          child: Card(
            elevation: 0,
            color: Styles.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 5),
              child: BarChartWidget(
                barData: getBarData(reportAll, pwsProvider),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ChartItemModel> getBarData(List<ReportModel> reportAll, PowerstripProvider pwsProvider) {
    List<ChartItemModel> barDataRumah = [];
    if (reportAll.isEmpty) {
      barDataRumah.add(
        ChartItemModel(
          id: 0,
          name: "",
          y: 0,
          color: Styles.accentColor,
        ),
      );
    }
    for (var i = 0; i < reportAll.length; i++) {
      var report = reportAll[i];
      var pwsName = pwsProvider.powerstrips.firstWhere((element) => element.pwsKey == report.pwsKey).pwsName;
      barDataRumah.add(
        ChartItemModel(
          id: i,
          name: pwsName,
          y: report.usage ~/ 1000,
          color: Styles.accentColor,
        ),
      );
    }
    return barDataRumah;
  }
}
