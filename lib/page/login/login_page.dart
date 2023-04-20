// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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
  bool _hidePassword = false;

  void _submitForm() {
    final form = _loginFormKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        // perform login with _email and _password
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailTextForm(),
          const Gap(16),
          PasswordTextForm(),
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
          CustomElevatedButton(
            backgroundColor: Styles.accentColor,
            borderColor: Styles.secondaryColor,
            text: "masuk",
            textStyle: Styles.buttonTextWhite,
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
              // context.goNamed("login_page");
            },
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
  });
  final String hintText;

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  bool _hidePassword = true;
  late String _hintText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hintText = widget.hintText;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
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
        if (!value!.isValidPassword) return 'Password harus terdiri dari 8 karakter dan mengandung huruf besar, huruf kecil, dan angka.';
      },
    );
  }
}

class EmailTextForm extends StatelessWidget {
  const EmailTextForm({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: "Email",
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      prefixIcon: Icons.mail_rounded,
      validator: (value) {
        if (!value!.isValidEmail) return 'Alamat email tidak valid';
      },
    );
  }
}
