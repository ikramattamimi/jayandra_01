// ignore_for_file: body_might_complete_normally_nullable, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/login/login_controller.dart';
import 'package:jayandra_01/page/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:jayandra_01/utils/form_regex.dart';

/// Widget ini menampilkan halaman Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Key untuk Form
  final _loginFormKey = GlobalKey<FormState>();

  /// Controller untuk form
  final LoginController _controller = LoginController();

  /// Apakah password disembunyikan dalam input [PasswordTextForm]
  bool _isPasswordHidden = false;

  /// Autentikasi akun user
  ///
  /// Menampilkan [SnackBar] dengan isi dari [response.message]
  /// dari [LoginController]
  void _login() async {
    // Jika validasi form berhasil
    if (_loginFormKey.currentState!.validate()) {
      // Menampilkan animasi loading
      setState(() {
        _controller.isLoading = true;
      });

      // Memproses API Login
      MyResponse response = await _controller.login();

      // Menyembunyikan animasi loading
      setState(() {
        _controller.isLoading = false;
      });

      // Menampilkan pesan status autentikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      // Menunggu 1 detik untuk memberikan kesempatan kepada pengguna
      // membaca pesan status autentikasi
      Future.delayed(Duration(seconds: 1), () {
        // Jika status autentikasi sukses dengan kode 0
        if (response.code == 0) {
          User user = response.data;
          // context.goNamed('main_page', extra: user);
          context.goNamed('main_page');
        } else {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.accentColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: CustomContainer(
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
                Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmailTextForm(
                        controller: _controller.emailController,
                        formKey: _loginFormKey,
                      ),
                      const Gap(16),
                      PasswordTextForm(
                        controller: _controller.passwordController,
                        formKey: _loginFormKey,
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

                      /// Apakah sistem sedang memproses data [_email] dan password
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget ini menampilkan [TextFormField] untuk field password.
///
/// Dilengkapi dengan toggle untuk menampilkan dan menyembunyikan
/// teks password.
class PasswordTextForm extends StatefulWidget {
  const PasswordTextForm({
    super.key,
    this.hintText = "Password",
    required this.formKey,
    this.controller,
  });
  final String hintText;
  final GlobalKey<FormState> formKey;
  final TextEditingController? controller;

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  /// Apakah teks password disembunyikan.
  bool _isPasswordHidden = true;

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
      obscureText: _isPasswordHidden,
      prefixIcon: Icons.lock,
      suffixIcon: IconButton(
        icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
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
