import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/custom_widget/custom_dropdown.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SocketReportWidget extends StatefulWidget {
  const SocketReportWidget({super.key});

  @override
  State<SocketReportWidget> createState() => _SocketReportWidgetState();
}

class _SocketReportWidgetState extends State<SocketReportWidget> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reportSocket = reportProvider.reportSocket;
    var total = 0.0;
    for (var report in reportSocket) {
      total += report.usage;
    }
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
            const CustomDropDown(list: [
              'Januari',
              'Februari',
              'Maret',
              'April',
              'Mei',
              'Juni',
              'Juli',
              'Agustus',
              'September',
              'Oktober',
              'November',
              'Desember',
            ])
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
                barData: getBarData(reportSocket),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ChartItemModel> getBarData(List<ReportModel> reports) {
    List<ChartItemModel> barDataRumah = [];
    for (var report in reports) {
      barDataRumah.add(
        ChartItemModel(
          id: report.socketNr - 1,
          name: "Socket ${report.socketNr}",
          y: report.usage ~/ 1000,
          color: Styles.accentColor,
        ),
      );
    }
    return barDataRumah;
  }
}
