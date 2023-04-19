// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/widget/white_container.dart';

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
            children: [
              Center(
                child: Column(
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
                          const Gap(24),
                          LoginForm(),
                        ],
                      ),
                    )
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
  bool _showPassword = false;

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
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.mail,
              ),
              // prefixIconColor: Styles.textColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Styles.accentColor2,
                ),
              ),
              hintText: 'Email',
              hintStyle: Styles.bodyTextBlack2,
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (!value!.isValidEmail) return 'Alamat email tidak valid';
            },
            onSaved: (value) => _email = value,
          ),
          const Gap(16),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
              ),
              suffixIcon: IconButton(
                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              // prefixIconColor: Styles.textColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Styles.accentColor2,
                ),
              ),
              hintText: 'Password',
              hintStyle: Styles.bodyTextBlack2,
              errorMaxLines: 2,
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (!value!.isValidPassword) return 'Password harus terdiri dari 8 karakter dan mengandung huruf besar, huruf kecil, dan angka.';
            },
            onSaved: (value) => _password = value,
          ),
          const Gap(24),
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
        ],
      ),
    );
  }
}

/// ****************************************************************************
/// Code    : Regex for Form Validation
/// Source  : https://blog.logrocket.com/flutter-form-validation-complete-guide/#input-validation-input-formatters
/// ****************************************************************************
extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    // ignore: unnecessary_null_comparison
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
