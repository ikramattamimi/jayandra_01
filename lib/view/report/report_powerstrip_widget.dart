import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportPowerstripWidget extends StatefulWidget {
  const ReportPowerstripWidget({super.key});

  @override
  State<ReportPowerstripWidget> createState() => _ReportPowerstripWidgetState();
}

class _ReportPowerstripWidgetState extends State<ReportPowerstripWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        Row(
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
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                  selectedPws = powerstrips.firstWhere((element) => element.pwsName == selectedOption);
                  getReportPws();
                  calculateTotal();
                });
              },
              items: pwsNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: Styles.bodyTextBlack2,
                  ),
                );
              }).toList(),
            )
          ],
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
                barData: getBarData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  String selectedOption = '';
  var reportPws = <ReportModel>[];
  var total = 0.0;
  late PowerstripModel selectedPws;
  late ReportProvider reportProvider;
  late PowerstripProvider pwsProvider;
  late List<PowerstripModel> powerstrips;
  late List<ReportModel> reports;
  late List<String> pwsNames;

  @override
  void initState() {
    super.initState();
    reportProvider = Provider.of<ReportProvider>(context, listen: false);
    pwsProvider = Provider.of<PowerstripProvider>(context, listen: false);
    powerstrips = pwsProvider.powerstrips;
    reports = reportProvider.reportPowerstrip;
    pwsNames = powerstrips.map((e) => e.pwsName).toList();

    selectedOption = pwsNames.first;
    selectedPws = powerstrips.firstWhere((element) => element.pwsName == selectedOption);

    getReportPws();
    calculateTotal();
  }

  getReportPws() {
    reportPws.clear();
    for (var pws in powerstrips) {
      if (pws.pwsKey == selectedPws.pwsKey) {
        reportPws.addAll(reports.where((element) => element.pwsKey == pws.pwsKey));
      }
    }
  }

  calculateTotal() {
    total = 0;
    for (var report in reportPws) {
      // report.logger();
      total += report.usage;
    }
  }

  List<ChartItemModel> getBarData() {
    List<ChartItemModel> barDataPws = [];
    for (var i = 0; i < reportPws.length; i++) {
      var report = reportPws[i];
      var pwsName = selectedPws.sockets.firstWhere((element) => element.socketNr == report.socketNr).name;
      barDataPws.add(
        ChartItemModel(
          id: i,
          name: pwsName,
          y: report.usage ~/ 1000,
          color: Styles.accentColor,
        ),
      );
    }
    return barDataPws;
  }
}
