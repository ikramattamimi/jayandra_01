import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/cek_email_controller.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/forgot_password/forgot_pw_otp_view.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:logger/logger.dart';

class ForgotPasswordEmailView extends StatelessWidget {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterElectricityClassView(
      title: "Lupa Password",
      subtitle: "Masukkan email Anda untuk melanjutkan",
      form: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _registerFormKey = GlobalKey<FormState>();
  final cekEmailController = CekEmailController();
  final registerController = RegisterController();

  // late String? _email;
  // late String? _password;
  // bool _showPassword = false;

  void _cekEmailOld() async {
    if (_registerFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        cekEmailController.isLoading = true;
      });

      // Memproses API cek email
      MyResponse response = await cekEmailController.cekEmail();

      // Menyembunyikan animasi loading
      setState(() {
        cekEmailController.isLoading = false;
      });

      // Menampilkan pesan dari controller
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (response.code == 1) {
          // context.pushNamed("register_page_2");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ForgotPasswordOTPView(email: cekEmailController.emailController.text);
          }));
        } else {}
      });
    }
  }

  void _cekEmail() async {
    if (_registerFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        cekEmailController.isLoading = true;
      });

      try {
        // Memproses API cek email
        final response = await Future.any([
          cekEmailController.cekEmail(),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        if (response.code == 0) {
          // Kirim OTP ke Email
          sendOTP(
            cekEmailController.emailController.text,
          );

          Future.delayed(const Duration(seconds: 2), () {
            // Menyembunyikan animasi loading
            setState(() {
              cekEmailController.isLoading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ForgotPasswordOTPView(email: cekEmailController.emailController.text);
            }));
          });
        } else {
          // Menampilkan pesan dari controller
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        setState(() {
          cekEmailController.isLoading = false;
        });

        // Menampilkan pesan dari controller
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger().e(err);
      }
    }
  }

  void sendOTP(String email) async {
    try {
      // Memproses API cek email
      final response = await Future.any([
        registerController.sendOTP(email),
        Future.delayed(
          const Duration(seconds: 10),
          () => throw TimeoutException('API call took too long'),
        ),
      ]);

      if (response.code == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          EmailTextForm(
            formKey: _registerFormKey,
            controller: cekEmailController.emailController,
          ),
          const Gap(20),
          (!cekEmailController.isLoading)
              ? NextButton(
                  onPressed: () => _cekEmail(),
                )
              : SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    color: Styles.accentColor,
                    strokeWidth: 3,
                  ),
                ),
          const Gap(20),
          Center(
            child: TextButton(
              onPressed: () {
                context.pushNamed("login_page");
              },
              child: Text(
                "Sudah punya akun? Masuk",
                style: Styles.buttonTextBlue,
              ),
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomElevatedButton(
        backgroundColor: Styles.accentColor,
        borderColor: Styles.secondaryColor,
        text: "lanjut",
        textStyle: Styles.buttonTextWhite,
        onPressed: onPressed,
      ),
    );
  }
}
