import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/view/report/bar_chart_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_dropdown.dart';

class HomeReportWidget extends StatefulWidget {
  const HomeReportWidget({super.key});

  @override
  State<HomeReportWidget> createState() => _HomeReportWidgetState();
}

class _HomeReportWidgetState extends State<HomeReportWidget> {
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
            const CustomDropDown(list: ['ikram', 'irpan'])
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
