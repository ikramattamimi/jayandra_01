import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jayandra_01/utils/app_styles.dart';

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
  });
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
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
    );
  }
}
