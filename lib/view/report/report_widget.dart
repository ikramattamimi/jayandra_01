import 'package:gap/gap.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return SizedBox(
      width: size.width,
      height: 232.0,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.accentColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LAPORAN PENGGUNAAN",
                  style: Styles.bodyTextWhite2,
                ),
                SizedBox(
                  width: 115,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.secondaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selengkapnya",
                          style: Styles.bodyTextBlack3,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 20,
                          color: Styles.textColor2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Rp 320.000",
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "Biaya digunakan oleh 3 powerstrip listrik",
                    style: Styles.bodyTextWhite3,
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
