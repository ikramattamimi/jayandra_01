import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class BarChartView extends StatelessWidget {
  // const BarChartView({super.key});

  List<ReportModel> barData = [
    ReportModel(
      id: 0,
      name: "Senin",
      y: 15,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 1,
      name: "Senin",
      y: 25,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 2,
      name: "Senin",
      y: 23,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 3,
      name: "Senin",
      y: 45,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 4,
      name: "Senin",
      y: 12,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 5,
      name: "Senin",
      y: 67,
      color: Styles.accentColor,
    ),
    ReportModel(
      id: 6,
      name: "Senin",
      y: 56,
      color: Styles.accentColor,
    ),
  ];

  SideTitles getTopBottomTitles() {
    return SideTitles(
      showTitles: true,
      // getTitlesWidget: (value, meta) => barData.firstWhere((element) => element.id == value.toInt()).name,
    );
  }

  final double barWidth = 22;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 85,
        minY: 0,
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
          show: true,
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: leftTitles,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: bottomTitles,
            ),
          ),
        ),
        barGroups: barData
            .map(
              (data) => BarChartGroupData(
                x: data.id,
                barRods: [
                  BarChartRodData(
                    toY: data.y.toDouble(),
                    width: barWidth,
                    color: data.color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: Styles.buttonTextBlue2,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12, //margin top
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var style = Styles.bodyTextGrey2;
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 20) {
      text = '20k';
    } else if (value == 40) {
      text = '40k';
    } else if (value == 40) {
      text = '40k';
    } else if (value == 60) {
      text = '60k';
    } else if (value == 80) {
      text = '80k';
    } else if (value == 100) {
      text = '100k';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}
