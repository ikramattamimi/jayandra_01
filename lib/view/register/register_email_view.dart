import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/module/register/cek_email_controller.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:logger/logger.dart';

class RegisterEmailView extends StatelessWidget {
  const RegisterEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterElectricityClassView(
      title: "Daftar",
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
  final _controller = CekEmailController();

  // late String? _email;
  // late String? _password;
  // bool _showPassword = false;

  void _cekEmail() async {
    if (_registerFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _controller.isLoading = true;
      });

      try {
        // Memproses API cek email
        final response = await Future.any([
          _controller.cekEmail(),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        setState(() {
          _controller.isLoading = false;
        });
        if (response.code == 1) {
          Future.delayed(const Duration(seconds: 2), () {
            context.pushNamed(
              "register_page_2",
              queryParams: {
                "email": _controller.emailController.text,
              },
            );
          });
        } else {
          // Menampilkan pesan dari controller
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        setState(() {
          _controller.isLoading = false;
        });

        // Menampilkan pesan dari controller
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger().e(err);
      }
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
            controller: _controller.emailController,
          ),
          const Gap(20),
          (!_controller.isLoading)
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
