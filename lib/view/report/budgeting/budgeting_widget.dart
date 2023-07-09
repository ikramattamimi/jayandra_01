import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class BudgetingWidget extends StatefulWidget {
  const BudgetingWidget({super.key, required this.progress, required this.home, required this.usage});

  final double progress;
  final HomeModel home;
  final double usage;

  @override
  State<BudgetingWidget> createState() => _BudgetingWidgetState();
}

class _BudgetingWidgetState extends State<BudgetingWidget> {
  double pg = 0.0;
  @override
  void initState() {
    super.initState();
    pg = widget.home.budget != 0.0 ? widget.usage / widget.home.budget * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          "budgeting_page",
          extra: widget.home,
          queryParams: {
            'budgetText': widget.home.budget.toInt().toString(),
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SimpleCircularProgressBar(
            //   size: 50,
            //   mergeMode: true,
            //   backStrokeWidth: 5,
            //   progressStrokeWidth: 5,
            //   valueNotifier: ValueNotifier(pg),
            //   backColor: Styles.textColor2,
            //   progressColors: [
            //     Styles.accentColor,
            //     Colors.red,
            //   ],
            //   onGetText: (double value) {
            //     return Text('${value.toInt()}%');
            //   },
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Budgeting",
                  style: Styles.headingStyle3,
                ),
                Text(
                  "${NumberFormat.currency(
                    symbol: "Rp ",
                    decimalDigits: 2,
                  ).format(widget.usage)} / ${NumberFormat.currency(
                    symbol: "Rp ",
                    decimalDigits: 2,
                  ).format(widget.home.budget)}",
                  style: Styles.bodyTextGrey3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
