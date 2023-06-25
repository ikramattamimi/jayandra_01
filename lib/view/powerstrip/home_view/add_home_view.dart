import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/module/home/home_controller.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddHomeView extends StatefulWidget {
  const AddHomeView({super.key});

  @override
  State<AddHomeView> createState() => _AddHomeViewState();
}

class _AddHomeViewState extends State<AddHomeView> {
  void setElClass(String elClass) {
    setState(() {
      homeController.elClassController.text = elClass;
    });
  }

  void setBudget(String budget) {
    setState(() {
      homeController.budgetingController.text = budget;
    });
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);
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
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Column(
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
            ],
          ),
          const Gap(32),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Gap(20),
                    Image.asset("assets/images/router.png"),
                    const Gap(32),
                    Form(
                      key: addHomeFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(12),
                          CustomTextFormField(
                            hintText: "Nama rumah",
                            formKey: addHomeFormKey,
                            controller: homeController.homeNameController,
                            keyboardType: TextInputType.name,
                            prefixIcon: Icons.home_rounded,
                            validator: (String? value) {
                              if (!value!.isValidName) {
                                return "Nama harus diisi";
                              } else {
                                addHomeFormKey.currentState!.save();
                                return null;
                              }
                            },
                          ),
                          const Gap(16),
                          InkWell(
                            onTap: () => context.pushNamed("electricity_class_add_home", extra: setElClass, queryParams: {
                              'selectedElClass': homeController.elClassController.text,
                            }),
                            child: AbsorbPointer(
                              absorbing: true,
                              child: CustomTextFormField(
                                formKey: addHomeFormKey,
                                controller: homeController.elClassController,
                                hintText: "Golongan Listrik",
                                prefixIcon: Icons.money,
                                suffixIcon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Golongan listrik harus diisi";
                                  } else {
                                    addHomeFormKey.currentState!.save();
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                          const Gap(16),
                          InkWell(
                            onTap: () => context.pushNamed(
                              "budgeting_page",
                              extra: setBudget,
                              queryParams: {
                                'budgetText': homeController.budgetingController.text,
                              },
                            ),
                            child: AbsorbPointer(
                              absorbing: true,
                              child: CustomTextFormField(
                                formKey: addHomeFormKey,
                                controller: homeController.budgetingController,
                                hintText: "Budget",
                                prefixIcon: Icons.money,
                                suffixIcon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const Gap(24),
                          if (!homeController.isLoading)
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CustomElevatedButton(
                                backgroundColor: Styles.accentColor,
                                borderColor: Styles.secondaryColor,
                                text: "tambah",
                                textStyle: Styles.buttonTextWhite,
                                onPressed: () async {
                                  try {
                                    addHome(homeProvider);
                                  } catch (err) {
                                    Logger().e(err);
                                  }
                                },
                              ),
                            )
                          else
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(
                                color: Styles.accentColor,
                                strokeWidth: 3,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ==========================================================================
  /// Deklarasi Variable
  /// ==========================================================================
  ///
  /// Key untuk Form
  final addHomeFormKey = GlobalKey<FormState>();
  final homeController = HomeController();

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// Autentikasi akun user
  ///
  /// Menampilkan [SnackBar] dengan isi dari [loginResponse.message]
  /// dari [LoginController]
  void addHome(HomeProvider homeProvider) async {
    // int id;
    // Jika validasi form berhasil
    if (addHomeFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        homeController.isLoading = true;
      });

      try {
        // Memproses API
        final addHomeResponse = await Future.any([
          homeController.addHome(context),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        setState(() {
          homeController.isLoading = false;
        });

        // Jika status autentikasi sukses dengan kode 0
        if (addHomeResponse.code == 0) {
          var budget = homeController.budgetingController.text;
          var className = homeController.elClassController.text;
          var homeName = homeController.homeNameController.text;
          var home = HomeModel(
            budget: budget.isNotEmpty ? double.parse(budget) : 0,
            className: className,
            homeName: homeName,
            // email: user,
          );
          homeProvider.addHome(home);

          // Menampilkan pesan status
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(addHomeResponse.message)),
          );

          // Menunggu 1 detik untuk memberikan kesempatan kepada pengguna
          // membaca pesan status autentikasi
          Future.delayed(const Duration(seconds: 1), () {
            context.pop();
          });
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        setState(() {
          homeController.isLoading = false;
        });

        // Menampilkan pesan dari controller
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger(printer: PrettyPrinter()).e(err);
      }
    }
  }
}
