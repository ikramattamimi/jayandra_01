import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSaved,
    this.formKey,
    this.initialValue,
    this.onChanged,
  });
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  GlobalKey<FormState>? formKey;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Styles.accentColor2,
          ),
        ),
        hintText: hintText,
        hintStyle: Styles.bodyTextGrey2,
        errorMaxLines: 2,
      ),
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
      onChanged: onChanged,
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
    this.confirmPassword,
    this.notifyParent,
  });
  final String hintText;
  final GlobalKey<FormState> formKey;
  final TextEditingController? controller;
  final String? confirmPassword;
  final Function? notifyParent;

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  /// Apakah teks password disembunyikan.
  bool _isPasswordHidden = true;

  late String _hintText;
  late GlobalKey<FormState> formKey;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _hintText = widget.hintText;
    formKey = widget.formKey;
    getSP();
  }

  void getSP() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? validator(String? value) {
    if (!value!.isValidPassword) {
      prefs.setString("passwordRegister", widget.controller!.text);
      return 'Password harus terdiri dari 8 karakter dan mengandung huruf besar, huruf kecil, dan angka.';
    } else {
      prefs.setString("passwordRegister", widget.controller!.text);
      formKey.currentState?.save();
      return null;
    }
  }

  String? confirmPwValidator() {
    if (!isValidRepeatPassword(prefs.getString("passwordRegister"), widget.controller!.text)) {
      return 'Password tidak cocok.';
    } else {
      formKey.currentState?.save();
      return null;
    }
  }

  bool isValidRepeatPassword(String? password, String? repeatPassword) {
    if (password != repeatPassword) {
      return false;
    }
    return true;
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
      validator: (String? value) {
        if (widget.confirmPassword == null) {
          return validator(value);
        } else {
          return confirmPwValidator();
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
          return null;
        }
      },
      onSaved: onSaved,
    );
  }
}
