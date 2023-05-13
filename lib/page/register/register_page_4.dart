import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/register/register_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:jayandra_01/widget/list_tile_view.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterPage4 extends StatefulWidget {
  const RegisterPage4({super.key, required this.email, required this.electricityClass});
  final String email;
  final String electricityClass;

  @override
  State<RegisterPage4> createState() => _RegisterPage4State();
}

class _RegisterPage4State extends State<RegisterPage4> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;
  late String _electricityClass;
  final _controller = RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = widget.email;
    _electricityClass = widget.electricityClass;
    print(_email);
    print(_electricityClass);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
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

      Future.delayed(Duration(seconds: 2), () {
        if (response.code == 0) {
          // context.goNamed("register_page_2");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        } else {}
      });
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
      ),
      const Gap(20),
      NextButton(
        onPressed: () => _register(),
      ),
      const Gap(8),
    ];
  }
}
