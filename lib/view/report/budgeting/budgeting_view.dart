import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/custom_widget/circle_icon_container.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class BudgetingView extends StatefulWidget {
  const BudgetingView({super.key});

  @override
  State<BudgetingView> createState() => _BudgetingViewState();
}

class _BudgetingViewState extends State<BudgetingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Budgeting",
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.secondaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(32),
                  Align(
                    alignment: Alignment.center,
                    child: CircleIconContainer(
                      width: 80,
                      height: 80,
                      color: Styles.accentColor,
                      icon: Icons.money,
                      iconSize: 40,
                      iconColor: Styles.secondaryColor,
                    ),
                  ),
                  const Gap(32),
                  Text(
                    "Budgeting adalah fitur perencanaan pembatasan biaya yang bisa digunakana oleh perangkat Jayandra Powerstrip. Anda akan mendapatkan notifikasi ketika penggunaan sudah mencapai batas-batas tertentu secara berkala.",
                    style: Styles.bodyTextBlack2,
                    textAlign: TextAlign.justify,
                  ),
                  const Gap(20),
                  // Text(
                  //   "Atur target pembatasan biaya (rupiah)",
                  //   style: Styles.bodyTextBlack2,
                  // ),
                  // const Gap(20),
                  CustomTextFormField(
                    hintText: "Tentukan target batas biaya (rupiah)",
                    keyboardType: TextInputType.number,
                    initialValue: "300000",
                  ),
                  const Gap(8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
