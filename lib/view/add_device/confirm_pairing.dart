import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';

class ConfirmPairingPage extends StatefulWidget {
  const ConfirmPairingPage({super.key});

  @override
  State<ConfirmPairingPage> createState() => _ConfirmPairingPageState();
}

class _ConfirmPairingPageState extends State<ConfirmPairingPage> {
  final pairingSteps = [
    "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Qui officia possimus",
    "assumenda voluptates quae, rem distinctio nihil aspernatur",
    "reiciendis ipsa consequuntur, cum officiis. Et quam itaque laborum alias, eligendi voluptates!"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Styles.primaryColor,
          centerTitle: true,
          foregroundColor: Styles.textColor,
          leading: IconButton(
            onPressed: () {
              context.pop();
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Styles.primaryColor,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.light,
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Styles.textColor,
              size: 20,
            ),
          ),
          // title: Text(
          //   "Tambah Powerstrip",
          //   style: Styles.bodyTextBlack,
          // ),
        ),
        backgroundColor: Styles.primaryColor,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            // padding: EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pastikan Perangkat Powerstrip Sudah Dalam Mode Pairing",
                    style: Styles.headingStyle4,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: WhiteContainer(
                      padding: 16,
                      margin: 0,
                      child: Column(
                        children: [
                          const Gap(12),
                          Text(
                            "Langkah-langkah untuk memasuki mode pairing:",
                            style: Styles.bodyTextGrey3,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          CustomList(
                            symbol: "1. ",
                            text: pairingSteps[0],
                          ),
                          CustomList(
                            symbol: "2. ",
                            text: pairingSteps[1],
                          ),
                          CustomList(
                            symbol: "3. ",
                            text: pairingSteps[2],
                          ),
                          const Gap(30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Styles.accentColor2,
                                size: 20,
                              ),
                              const Gap(8),
                              Text(
                                "Perangkat sudah dalam mode pairing",
                                style: TextStyle(
                                  color: Styles.accentColor2,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          ElevatedButton(
                            onPressed: () {
                              context.pushNamed("adding_device");
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(30, 42),
                            ),
                            child: Text(
                              "Selanjutnya",
                              style: Styles.bodyTextWhite3,
                            ),
                          ),
                          const Gap(20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CustomList extends StatelessWidget {
  const CustomList({super.key, this.symbol = "• ", required this.text});
  final String symbol;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          symbol,
          style: Styles.bodyTextGrey3,
        ),
        Expanded(
          child: Text(
            text,
            style: Styles.bodyTextGrey3,
          ),
        ),
      ],
    );
  }
}
