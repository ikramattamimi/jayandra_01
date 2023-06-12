import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jayandra_01/models/chart_item_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class BarChartWidget extends StatelessWidget {
  // const BarChartView({super.key});
  BarChartWidget({super.key, required this.barData});

  final List<ChartItemModel> barData;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        groupsSpace: 50,
        maxY: getMaxY(),
        minY: 0,
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
          show: true,
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Styles.accentColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${(rod.toY).toInt().toString()}k',
                Styles.bodyTextWhite3,
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: leftTitles,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
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
                barsSpace: 40,
                x: data.id,
                barRods: [
                  BarChartRodData(
                    toY: data.y.toDouble(),
                    width: barWidth,
                    color: data.color,
                    borderRadius: const BorderRadius.only(
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

  SideTitles getTopBottomTitles() {
    return SideTitles(
      showTitles: true,
      // getTitlesWidget: (value, meta) => barData.firstWhere((element) => element.id == value.toInt()).name,
    );
  }

  final double barWidth = 22;

  Widget bottomTitles(double value, TitleMeta meta) {
    // final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];
    final titles = barData.map((e) => e.name);

    final Widget text = Text(
      titles.elementAt(value.toInt()),
      style: Styles.buttonTextBlue2,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12, //margin top
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var style = Styles.bodyTextGrey3;
    String text;
    if (value <= 0) {
      text = '0';
    } else if (value >= 0) {
      text = '${value.toInt()}k';
      // } else if (value == 40) {
      //   text = '40k';
      // } else if (value == 40) {
      //   text = '40k';
      // } else if (value == 60) {
      //   text = '60k';
      // } else if (value == 80) {
      //   text = '80k';
      // } else if (value == 100) {
      //   text = '100k';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  double getMaxY() {
    var max = barData.map((e) => e.y).reduce((value, element) => value > element ? value : element).toDouble();
    double roundedValue = (max / 10).ceil() * 10;
    return roundedValue;
  }
}
