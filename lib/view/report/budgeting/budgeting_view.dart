import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      ),
      body: ListView(
        children: [
          Card(),
        ],
      ),
    );
  }
}
