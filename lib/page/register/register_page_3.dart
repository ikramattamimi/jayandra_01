import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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

class RegisterPage3 extends StatelessWidget {
  const RegisterPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
      subtitle: "Masukkan Nama, Password, dan Golongan Listrik",
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
  final _registerForm3Key = GlobalKey<FormState>();
  late String? _email;
  // late String? _password;
  // bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerForm3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _getRegisterFormWidget,
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

  List<Widget> get _getRegisterFormWidget {
    return [
      CustomTextFormField(
        hintText: "Nama",
        keyboardType: TextInputType.name,
        obscureText: false,
        prefixIcon: Icons.person_rounded,
        validator: (value) {
          if (!value!.isValidName) return 'Nama tidak valid';
        },
      ),
      const Gap(16),
      WhiteContainer(
        borderColor: Styles.textColor2,
        margin: 0,
        padding: 0,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          minLeadingWidth: 20,
          horizontalTitleGap: 10,
          onTap: () {
            context.goNamed("electricity_class_register_page");
          },
          leading: Icon(
            Icons.money,
            color: Styles.textColor3,
          ),
          title: Text(
            "Golongan Listrik",
            style: Styles.bodyTextBlack2,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Styles.textColor3,
          ),
        ),
      ),
      const Gap(16),
      PasswordTextForm(),
      const Gap(16),
      PasswordTextForm(
        hintText: "Konfirmasi Password",
      ),
      const Gap(20),
      NextButton(
        onPressed: () {
          if (_registerForm3Key.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengecek Kode OTP')),
            );
            Future.delayed(Duration(seconds: 0), () {
              context.goNamed("register_page_3");
            });
          }
        },
      ),
      const Gap(8),
    ];
  }
}
