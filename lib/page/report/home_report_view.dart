import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/page/report/bar_chart_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/button_filter.dart';
import 'package:jayandra_01/widget/custom_dropdown.dart';

class HomeReportView extends StatefulWidget {
  const HomeReportView({super.key});

  @override
  State<HomeReportView> createState() => _HomeReportViewState();
}

class _HomeReportViewState extends State<HomeReportView> {
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
                  "Rp 150,000",
                  style: Styles.headingStyle3,
                ),
                Text(
                  "Biaya digunakan bulan ini",
                  style: Styles.bodyTextGrey3,
                )
              ],
            ),
            CustomDropDown(list: ['ikram', 'irpan'])
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
              child: BarChartView(
                barData: barDataRumah,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ChartItemModel> barDataRumah = [
    ChartItemModel(
      id: 0,
      name: "Rumah 1",
      y: 15,
      color: Styles.accentColor,
    ),
    ChartItemModel(
      id: 1,
      name: "Rumah 2",
      y: 25,
      color: Styles.accentColor,
    ),
    ChartItemModel(
      id: 2,
      name: "Rumah 3",
      y: 23,
      color: Styles.accentColor,
    ),
  ];
}
