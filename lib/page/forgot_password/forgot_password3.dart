import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/register/register_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';

class ForgotPasswordPage3 extends StatefulWidget {
  const ForgotPasswordPage3({super.key, required this.email});
  final String email;

  @override
  State<ForgotPasswordPage3> createState() => _ForgotPasswordPage3State();
}

class _ForgotPasswordPage3State extends State<ForgotPasswordPage3> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;
  late String _electricityClass;
  final _controller = RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = widget.email;
    print(_email);
    print(_electricityClass);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
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

  void _submitForm() {
    final form = _registerForm3Key.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        // perform login with _email and _password
      }
    }
  }

  void _register() async {
    if (_registerForm3Key.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _controller.isLoading = true;
      });

      _controller.emailValue = _email;
      _controller.electricityClassValue = _electricityClass;

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
            return const LoginPage();
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
