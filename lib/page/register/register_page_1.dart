import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/register/register_page.dart';
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
  late String? _email;
  // late String? _password;
  // bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _getRegisterFormWidget,
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
    return [
      // const EmailTextForm(),
      const Gap(20),
      NextButton(
        onPressed: () {
          if (_registerFormKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengirimkan Kode OTP ke email')),
            );
            Future.delayed(Duration(seconds: 0), () {
              context.goNamed("register_page_2");
            });
          }
        },
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
    ];
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      backgroundColor: Styles.accentColor,
      borderColor: Styles.secondaryColor,
      text: "lanjut",
      textStyle: Styles.buttonTextWhite,
      onPressed: onPressed,
    );
  }
}
