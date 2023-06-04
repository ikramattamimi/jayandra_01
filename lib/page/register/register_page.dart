// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/white_container.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, required this.subtitle, required this.form, this.description, required this.title});
  final String subtitle;
  final String? description;
  final Widget form;
  final String title;

  List<Widget> get _getRegisterWidget {
    return [
      CircleIconContainer(
        width: 70,
        height: 70,
        color: Styles.secondaryColor,
        icon: Icons.electric_bolt_rounded,
        iconSize: 50,
        iconColor: Styles.accentColor,
      ),
      const Gap(24),
      Text(
        title,
        style: Styles.headingStyleWhite1,
      ),
      const Gap(10),
      Text(
        subtitle,
        style: Styles.bodyTextWhite2,
      ),
      const Gap(32),
      WhiteContainer(
        borderColor: Colors.transparent,
        padding: 16,
        margin: 0,
        child: Column(
          children: [
            const Gap(12),
            form,
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.accentColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          CustomContainer(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getRegisterWidget,
          ),
        ],
      ),
    );
  }
}
