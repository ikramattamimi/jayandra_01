import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/view/report/budgeting/budgeting_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportHomeWidget extends StatefulWidget {
  const ReportHomeWidget({super.key});

  @override
  State<ReportHomeWidget> createState() => _ReportHomeWidgetState();
}

class _ReportHomeWidgetState extends State<ReportHomeWidget> {
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
                  selectedHome = homes.firstWhere((element) => element.homeName == selectedOption);
                  getReportHome(powerstrips, reports);
                  calculateTotal();
                  progress = selectedHome.budget != 0.0 ? total / selectedHome.budget * 100 : 0;
                });
              },
              items: homeNames.map<DropdownMenuItem<String>>((String value) {
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
                barData: getBarData(reportHome, pwsProvider),
              ),
            ),
          ),
        ),
        BudgetingWidget(
          progress: progress,
          usage: total,
          home: selectedHome,
        ),
      ],
    );
  }

  /// ==========================================================================
  /// Variable Init
  /// ==========================================================================
  String selectedOption = '';
  var reportHome = <ReportModel>[];
  var total = 0.0;
  late HomeModel selectedHome;
  late ReportProvider reportProvider;
  late PowerstripProvider pwsProvider;
  late HomeProvider homeProvider;
  late List<HomeModel> homes;
  late List<PowerstripModel> powerstrips;
  late List<ReportModel> reports;
  late List<String> homeNames;
  var progress = 0.0;

  @override
  void initState() {
    super.initState();
    reportProvider = Provider.of<ReportProvider>(context, listen: false);
    pwsProvider = Provider.of<PowerstripProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homes = homeProvider.homes;
    powerstrips = pwsProvider.powerstrips;
    reports = reportProvider.reportHome;
    homeNames = homes.map((e) => e.homeName).toList();
    selectedOption = homeNames.isEmpty ? "" : homeNames.first;
    selectedHome = homes.isNotEmpty ? homes.firstWhere((element) => element.homeName == selectedOption) : HomeModel();
    progress = selectedHome.budget != 0.0 ? total / selectedHome.budget * 100 : 0;
    getReportHome(powerstrips, reports);
    calculateTotal();
  }

  getReportHome(List<PowerstripModel> powerstrips, List<ReportModel> reports) {
    reportHome.clear();
    for (var pws in powerstrips) {
      if (pws.homeId == selectedHome.homeId && reportHome.isNotEmpty) {
        reportHome.add(reports.firstWhere((element) => element.pwsKey == pws.pwsKey));
      }
    }
  }

  calculateTotal() {
    total = 0;
    for (var report in reportHome) {
      // report.logger();
      total += report.usage;
    }
  }

  List<ChartItemModel> getBarData(List<ReportModel> reports, PowerstripProvider pwsProvider) {
    List<ChartItemModel> barDataRumah = [];
    if (reports.isEmpty) {
      barDataRumah.add(
        ChartItemModel(
          id: 0,
          name: "",
          y: 0,
          color: Styles.accentColor,
        ),
      );
    }
    for (var i = 0; i < reports.length; i++) {
      var report = reports[i];
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
