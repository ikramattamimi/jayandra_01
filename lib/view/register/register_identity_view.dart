import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterIdentityView extends StatefulWidget {
  const RegisterIdentityView({super.key, required this.email});
  final String email;

  @override
  State<RegisterIdentityView> createState() => _RegisterIdentityViewState();
}

class _RegisterIdentityViewState extends State<RegisterIdentityView> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;
  final _controller = RegisterController();
  String password = "";

  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Daftar",
      subtitle: "Masukkan Nama dan Password",
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

      try {
        // Memproses API cek email
        final registerResponse = await Future.any([
          _controller.register(),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        setState(() {
          _controller.isLoading = false;
        });

        // Menampilkan pesan dari controller
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(registerResponse.message)),
        );

        if (registerResponse.code == 0) {
          UserModel user = registerResponse.data;

          final prefs = await SharedPreferences.getInstance();

          // simpan status user sudah login
          await prefs.setBool('isUserLoggedIn', true);
          await prefs.setString('user_name', user.name);
          await prefs.setString('email', user.email);

          Future.delayed(const Duration(seconds: 2), () {
            context.goNamed("main_page");
          });
        }
      } catch (err) {
        Logger().e(err);
      }
    }
  }

  List<Widget> get _getRegisterFormWidget {
    return [
      CustomTextFormField(
        controller: _controller.nameController,
        hintText: "Nama",
        keyboardType: TextInputType.name,
        obscureText: false,
        prefixIcon: Icons.person_rounded,
        validator: (value) {
          if (!value!.isValidName) return 'Nama tidak valid';
          return null;
        },
      ),
      const Gap(16),
      PasswordTextForm(
        formKey: _registerForm3Key,
        controller: _controller.passwordController,
      ),
      const Gap(16),
      PasswordTextForm(
        hintText: "Konfirmasi Password",
        formKey: _registerForm3Key,
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
