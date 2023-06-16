import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';

class AddHomeView extends StatefulWidget {
  const AddHomeView({super.key});

  @override
  State<AddHomeView> createState() => _AddHomeViewState();
}

class _AddHomeViewState extends State<AddHomeView> {
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
                  "Tambah Rumah",
                  style: Styles.headingStyle3,
                ),
                const Gap(12),
                Text(
                  "Rumah digunakan Untuk Mengelompokkan Powerstrip",
                  style: Styles.bodyTextGrey3,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(12),
                              Text(
                                "Nama Rumah",
                                style: Styles.title,
                              ),
                              const Gap(12),
                              CustomTextFormField(
                                hintText: "Nama rumah",
                                keyboardType: TextInputType.name,
                                prefixIcon: Icons.home_rounded,
                              ),
                              const Gap(24),
                              ElevatedButton(
                                onPressed: () {
                                  context.pushNamed("confirm_pairing");
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(30, 42),
                                ),
                                child: Text(
                                  "Selesai",
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
