import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';

class PairingView extends StatefulWidget {
  const PairingView({super.key});

  @override
  State<PairingView> createState() => _PairingViewState();
}

class _PairingViewState extends State<PairingView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Styles.primaryColor,
          centerTitle: true,
          foregroundColor: Styles.textColor,
          leading: TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "Batal",
              style: Styles.bodyTextGrey3,
            ),
          ),
          // title: Text(
          //   "Tambah Powerstrip",
          //   style: Styles.bodyTextBlack,
          // ),
        ),
        backgroundColor: Styles.primaryColor,
        body: Container(
          margin: const EdgeInsets.all(16),
          // padding: EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pilih Jaringan Wifi dan Inputkan Password",
                  style: Styles.headingStyle4,
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  "Jaringan wifi yang digunakan adalah wifi yang sudah tersambung dengan smartphone",
                  style: Styles.bodyTextGrey3,
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
                        const Gap(20),
                        Image.asset("assets/images/router.png"),
                        const Gap(32),
                        Form(
                          child: Column(
                            children: [
                              CustomTextFormField(
                                hintText: "Wifi",
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                prefixIcon: Icons.wifi_rounded,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.compare_arrows_rounded),
                                  onPressed: () {},
                                ),
                              ),
                              const Gap(16),
                              PasswordTextForm(formKey: _formKey),
                              const Gap(24),
                              ElevatedButton(
                                onPressed: () {
                                  context.pushNamed("confirm_pairing");
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
