import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class ButtonFilter extends StatelessWidget {
  const ButtonFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {},
      child: Card(
        elevation: 0,
        color: Styles.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 8, top: 5, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Juni",
                style: Styles.bodyTextWhite3,
              ),
              const Gap(3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Styles.textColor2,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
