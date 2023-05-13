import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/cek_email_controller.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/register/register_page.dart';
import 'package:jayandra_01/page/register/register_page_2.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterPage1 extends StatelessWidget {
  const RegisterPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
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

      // Memproses API cek email
      MyResponse response = await _controller.cekEmail();

      // Menyembunyikan animasi loading
      setState(() {
        _controller.isLoading = false;
      });

      // Menampilkan pesan dari controller
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Future.delayed(Duration(seconds: 2), () {
        if (response.code == 1) {
          // context.goNamed("register_page_2");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegisterPage2(email: _controller.emailController.text);
          }));
        } else {}
      });
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
                context.goNamed("login_page");
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

  void _submitForm() {
    final form = _registerFormKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        // perform login with _email and _password
      }
    }
  }

  List<Widget> get _getRegisterFormWidget {
    return [];
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
