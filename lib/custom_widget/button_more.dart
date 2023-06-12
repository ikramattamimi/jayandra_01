import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class ButtonMore extends StatelessWidget {
  const ButtonMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {},
        child: Card(
          color: Styles.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Selengkapnya",
                  style: Styles.bodyTextBlack3,
                ),
                const Gap(3),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Styles.textColor2,
                  size: 12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
