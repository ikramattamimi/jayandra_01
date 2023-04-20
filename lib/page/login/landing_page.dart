import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/widget/white_container.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.accentColor,
      body: SafeArea(
        child: CustomContainer(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jayandra Powerstrip",
              style: Styles.headingStyleWhite1,
            ),
            Expanded(
              child: Center(
                child: CircleIconContainer(
                  width: 70,
                  height: 70,
                  color: Styles.secondaryColor,
                  icon: Icons.electric_bolt_rounded,
                  iconSize: 50,
                  iconColor: Styles.accentColor,
                ),
              ),
            ),
            Text(
              "Pantau dan Kendalikan",
              style: Styles.headingStyleWhite2,
            ),
            const Gap(8),
            Text(
              "Pantau penggunaan listrik dan kendalikan terminal dari Jayandra Powerstrip",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Styles.secondaryColor,
                fontSize: 14,
              ),
            ),
            const Gap(32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomElevatedButton(
                  backgroundColor: Styles.secondaryColor,
                  borderColor: Styles.secondaryColor,
                  text: "masuk",
                  textStyle: Styles.buttonTextBlue,
                  onPressed: () {
                    context.goNamed("login_page");
                  },
                ),
                const Gap(10),
                CustomElevatedButton(
                  backgroundColor: Styles.accentColor,
                  borderColor: Styles.secondaryColor,
                  text: "Daftar",
                  textStyle: Styles.buttonTextWhite,
                  onPressed: () {
                    context.goNamed("register_page");
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
