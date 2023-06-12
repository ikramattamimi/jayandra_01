import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class SocketReportWidget extends StatefulWidget {
  const SocketReportWidget({super.key});

  @override
  State<SocketReportWidget> createState() => _SocketReportWidgetState();
}

class _SocketReportWidgetState extends State<SocketReportWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        // Text(
        //   "Laporan Per Socket",
        //   style: Styles.title,
        // ),
        const Gap(10),
        SizedBox(
          height: 200,
          child: Card(
            elevation: 0,
            color: Styles.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
              child: BarChartWidget(
                barData: barDataSocket,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ChartItemModel> barDataSocket = [
    ChartItemModel(
      id: 0,
      name: "Socket 1",
      y: 15,
      color: Styles.accentColor,
    ),
    ChartItemModel(
      id: 1,
      name: "Socket 2",
      y: 25,
      color: Styles.accentColor,
    ),
    ChartItemModel(
      id: 2,
      name: "Socket 3",
      y: 23,
      color: Styles.accentColor,
    ),
    ChartItemModel(
      id: 3,
      name: "Socket 4",
      y: 45,
      color: Styles.accentColor,
    ),
  ];
}
