import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BudgetingWidget extends StatelessWidget {
  const BudgetingWidget({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('budgeting_page');
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleCircularProgressBar(
              size: 50,
              mergeMode: true,
              backStrokeWidth: 5,
              progressStrokeWidth: 5,
              valueNotifier: ValueNotifier(70),
              backColor: Styles.textColor2,
              progressColors: [
                Styles.accentColor,
                Colors.red,
              ],
              onGetText: (double value) {
                return Text('${value.toInt()}%');
              },
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Budgeting",
                  style: Styles.title,
                ),
                Text(
                  "Rp 170,000 / Rp 300,000",
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
