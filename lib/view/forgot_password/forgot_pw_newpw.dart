// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/module/user/login_controller.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:logger/logger.dart';

class ForgotPasswordNewPwView extends StatefulWidget {
  const ForgotPasswordNewPwView({super.key, required this.email});
  final String email;

  @override
  State<ForgotPasswordNewPwView> createState() => _ForgotPasswordNewPwViewState();
}

class _ForgotPasswordNewPwViewState extends State<ForgotPasswordNewPwView> {
  final forgotPwKey = GlobalKey<FormState>();
  late String _email;
  final _controller = RegisterController();
  final _loginController = LoginController();
  String password = "";
  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Lupa Password",
      subtitle: "Masukkan Password Baru",
      form: Form(
        key: forgotPwKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getRegisterFormWidget,
        ),
      ),
    );
  }

  void _register() async {
    // int id;
    // Jika validasi form berhasil
    if (forgotPwKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _loginController.isLoading = true;
      });

      try {
        // Memproses API
        final changePwResponse = await Future.any([
          _loginController.changePassword(_email, _controller.passwordController.text),
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
          SnackBar(content: Text(changePwResponse.message)),
        );

        // Jika status autentikasi sukses dengan kode 0
        if (changePwResponse.code == 0) {
          context.goNamed("login_page");
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan dari controller
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger(printer: PrettyPrinter()).e(err);
      }
    }
  }

  List<Widget> get _getRegisterFormWidget {
    return [
      const Gap(16),
      PasswordTextForm(
        formKey: forgotPwKey,
        controller: _controller.passwordController,
      ),
      const Gap(16),
      PasswordTextForm(
        hintText: "Konfirmasi Password",
        formKey: forgotPwKey,
        controller: _controller.repeatPasswordController,
        confirmPassword: password,
      ),
      const Gap(20),
      NextButton(
        onPressed: () => _register(),
      ),
      const Gap(8),
    ];
  }
}
