// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';

class ForgotPasswordNewPwView extends StatefulWidget {
  const ForgotPasswordNewPwView({super.key, required this.email});
  final String email;

  @override
  State<ForgotPasswordNewPwView> createState() => _ForgotPasswordNewPwViewState();
}

class _ForgotPasswordNewPwViewState extends State<ForgotPasswordNewPwView> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;
  final _controller = RegisterController();

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
        key: _registerForm3Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getRegisterFormWidget,
        ),
      ),
    );
  }

  void _register() async {
    if (_registerForm3Key.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _controller.isLoading = true;
      });

      _controller.emailValue = _email;

      // Memproses API cek email
      MyResponse response = await _controller.register();

      // Menyembunyikan animasi loading
      setState(() {
        _controller.isLoading = false;
      });

      // Menampilkan pesan dari controller
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (response.code == 0) {
          // context.pushNamed("register_page_2");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginView();
          }));
        } else {}
      });
    }
  }

  List<Widget> get _getRegisterFormWidget {
    return [
      const Gap(16),
      PasswordTextForm(
        formKey: _registerForm3Key,
        controller: _controller.passwordController,
      ),
      const Gap(16),
      PasswordTextForm(
        hintText: "Konfirmasi Password",
        formKey: _registerForm3Key,
      ),
      const Gap(20),
      NextButton(
        onPressed: () => _register(),
      ),
      const Gap(8),
    ];
  }
}
