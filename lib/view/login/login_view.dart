// ignore_for_file: body_might_complete_normally_nullable, unused_field, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/module/user/login_controller.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:jayandra_01/view/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/circle_icon_container.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jayandra_01/models/init_models.dart';

/// Widget ini menampilkan halaman Login
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /// ==========================================================================
  /// Widget Page
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context, listen: false);
    final powerstripProvider = Provider.of<PowerstripProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
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
            children: [
              CircleIconContainer(
                width: 70,
                height: 70,
                color: Styles.secondaryColor,
                icon: Icons.electric_bolt_rounded,
                iconSize: 50,
                iconColor: Styles.accentColor,
              ),
              const Gap(48),
              Text(
                "Selamat Datang",
                style: Styles.headingStyleWhite1,
              ),
              const Gap(10),
              Text(
                "Silahkan masuk ke akun Anda",
                style: Styles.bodyTextWhite2,
              ),
              const Gap(32),
              WhiteContainer(
                borderColor: Colors.transparent,
                padding: 16,
                margin: 0,
                child: Column(
                  children: [
                    const Gap(8),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmailTextForm(
                            controller: _loginController.emailController,
                            formKey: _loginFormKey,
                          ),
                          const Gap(16),
                          PasswordTextForm(
                            controller: _loginController.passwordController,
                            formKey: _loginFormKey,
                          ),
                          const Gap(8),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  context.goNamed('forgot_password_page');
                                },
                                child: Text(
                                  "Lupa Password?",
                                  style: Styles.buttonTextBlue,
                                )),
                          ),
                          const Gap(20),

                          /// Apakah sistem sedang memproses data [_email] dan password
                          (!_loginController.isLoading)
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CustomElevatedButton(
                                    backgroundColor: Styles.accentColor,
                                    borderColor: Styles.secondaryColor,
                                    text: "masuk",
                                    textStyle: Styles.buttonTextWhite,
                                    onPressed: () async {
                                      try {
                                        _login(userProvider);
                                        initModels(
                                          userProvider: userProvider,
                                          powerstripProvider: powerstripProvider,
                                          timerProvider: timerProvider,
                                          scheduleProvider: scheduleProvider,
                                          homeProvider: homeProvider,
                                        );
                                        goToDashboard();
                                      } catch (err) {
                                        Logger().e(err);
                                      }
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircularProgressIndicator(
                                    color: Styles.accentColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                          const Gap(8),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.pushNamed("register_page");
                              },
                              child: Text(
                                "Belum punya akun? Daftar",
                                style: Styles.buttonTextBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// Deklarasi Variable
  /// ==========================================================================
  ///
  /// Key untuk Form
  final _loginFormKey = GlobalKey<FormState>();

  /// Controller untuk form login
  final LoginController _loginController = LoginController();

  /// Controller untuk mendapatkan data powerstrip ketika login berhasil
  final _powerstripController = PowerstripController();

  /// Apakah password disembunyikan dalam input [PasswordTextForm]
  final bool _isPasswordHidden = false;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  ///
  /// Autentikasi akun user
  ///
  /// Menampilkan [SnackBar] dengan isi dari [loginResponse.message]
  /// dari [LoginController]
  void _login(UserModel userProvider) async {
    // int id;
    // Jika validasi form berhasil
    if (_loginFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _loginController.isLoading = true;
      });

      try {
        // Memproses API
        final loginResponse = await Future.any([
          _loginController.login(),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan status autentikasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginResponse.message)),
        );

        // Jika status autentikasi sukses dengan kode 0
        if (loginResponse.code == 0) {
          var user = loginResponse.data;
          userProvider.updateUser(
            userId: user.userId,
            name: user.name,
            email: user.email,
          );

          userProvider.logger();

          final prefs = await SharedPreferences.getInstance();

          // simpan status user sudah login
          await Future.any([
            prefs.setBool('isUserLoggedIn', true),
            prefs.setString('user_name', user.name),
            prefs.setString('email', user.email),
            prefs.setInt('user_id', user.userId),
          ]);
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan dari controller
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger(printer: PrettyPrinter()).e(err);
      }
    }
  }

  void goToDashboard() {
    // Menunggu 3 detik untuk melakukan pengambilan data
    Future.delayed(const Duration(seconds: 6), () {
      context.pushNamed('main_page');
    });
  }
}
