import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class BudgetingPage extends StatefulWidget {
  const BudgetingPage({super.key});

  @override
  State<BudgetingPage> createState() => _BudgetingPageState();
}

class _BudgetingPageState extends State<BudgetingPage> {
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
