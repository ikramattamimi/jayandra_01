import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';

class RegisterIdentityView extends StatefulWidget {
  const RegisterIdentityView({super.key, required this.email, required this.electricityClass});
  final String email;
  final String electricityClass;

  @override
  State<RegisterIdentityView> createState() => _RegisterIdentityViewState();
}

class _RegisterIdentityViewState extends State<RegisterIdentityView> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;
  late String _electricityClass;
  final _controller = RegisterController();

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _electricityClass = widget.electricityClass;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Daftar",
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (response.code == 0) {
          // context.pushNamed("register_page_2");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginView();
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
          return null;
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
