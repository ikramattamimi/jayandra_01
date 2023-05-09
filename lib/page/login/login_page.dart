// ignore_for_file: body_might_complete_normally_nullable, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/login/login_controller.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:jayandra_01/utils/form_regex.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
                    LoginForm(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _loginFormKey = GlobalKey<FormState>();
  late String? _email;
  late String? _password;
  // ignore: prefer_final_fields
  bool _hidePassword = false;

  final LoginController _controller = LoginController();

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      setState(() {
        _controller.isLoading = true;
      });

      MyResponse response = await _controller.login();

      setState(() {
        _controller.isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      
      

      if (response.code == 0) {
        context.goNamed('main_page');
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EmailTextForm(
            controller: _controller.emailController,
            formKey: _loginFormKey,
            onSaved: (value) => _email = value,
          ),
          const Gap(16),
          PasswordTextForm(
            controller: _controller.passwordController,
            formKey: _loginFormKey,
            onSaved: (value) => _password = value,
          ),
          const Gap(8),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {},
                child: Text(
                  "Lupa Password?",
                  style: Styles.buttonTextBlue,
                )),
          ),
          const Gap(20),
          (!_controller.isLoading)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    backgroundColor: Styles.accentColor,
                    borderColor: Styles.secondaryColor,
                    text: "masuk",
                    textStyle: Styles.buttonTextWhite,
                    onPressed: _login,
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
                context.goNamed("register_page");
              },
              child: Text(
                "Belum punya akun? Daftar",
                style: Styles.buttonTextBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordTextForm extends StatefulWidget {
  const PasswordTextForm({
    super.key,
    this.hintText = "Password",
    this.onSaved,
    required this.formKey,
    this.controller,
  });
  final String hintText;
  final void Function(String?)? onSaved;
  final GlobalKey<FormState> formKey;
  final TextEditingController? controller;

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  bool _hidePassword = true;
  late String _hintText;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hintText = widget.hintText;
    _formKey = widget.formKey;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hintText: _hintText,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _hidePassword,
      prefixIcon: Icons.lock,
      suffixIcon: IconButton(
        icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _hidePassword = !_hidePassword;
          });
        },
      ),
      validator: (value) {
        if (!value!.isValidPassword) {
          return 'Password harus terdiri dari 8 karakter dan mengandung huruf besar, huruf kecil, dan angka.';
        } else {
          widget.formKey.currentState?.save();
        }
      },
      onSaved: widget.onSaved,
    );
  }
}

class EmailTextForm extends StatelessWidget {
  const EmailTextForm({super.key, this.onSaved, required this.formKey, this.controller});
  final void Function(String?)? onSaved;
  final GlobalKey<FormState> formKey;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: "Email",
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      prefixIcon: Icons.mail_rounded,
      validator: (value) {
        if (!value!.isValidEmail) {
          return 'Alamat email tidak valid';
        } else {
          formKey.currentState?.save();
        }
      },
      onSaved: onSaved,
    );
  }
}
