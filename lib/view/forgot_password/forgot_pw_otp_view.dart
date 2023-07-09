// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/forgot_password/forgot_pw_newpw.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOTPView extends StatefulWidget {
  const ForgotPasswordOTPView({super.key, required this.email});
  final String email;

  @override
  State<ForgotPasswordOTPView> createState() => _ForgotPasswordOTPViewState();
}

class _ForgotPasswordOTPViewState extends State<ForgotPasswordOTPView> {
  final _registerForm2Key = GlobalKey<FormState>();
  late String _email;
  final registerController = RegisterController();

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Lupa Password",
      subtitle: "Masukkan Kode OTP yang sudah dikirimkan ke email",
      form: Form(
        key: _registerForm2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getRegisterFormWidget,
        ),
      ),
    );
  }

  TextEditingController otpTextController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    _email = widget.email;
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // ignore: unused_field
  late Timer _timer;
  int _start = 30;
  late String _resendTimer;
  bool _isButtonDisabled = true;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _resendTimer = '($_start' 'd)';
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isButtonDisabled = false;
            _resendTimer = '';
          });
        } else {
          setState(() {
            _start--;
            _resendTimer = '($_start' 'd)';
          });
        }
      },
    );
  }

   void resendOTP() async {
    if (!_isButtonDisabled) {
      try {
        // Memproses API cek email
        final response = await Future.any([
          registerController.sendOTP(_email),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        if (response.code == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      } catch (e) {
        Logger().e(e);
      }
    }
  }

  List<Widget> get _getRegisterFormWidget {
    return [
      PinCodeTextField(
        appContext: context,
        length: 4,
        obscureText: false,
        obscuringCharacter: '*',
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        validator: (v) {
          if (v!.length < 4) {
            return "Kode OTP tidak valid";
          } else {
            return null;
          }
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 50,
          fieldWidth: 50,
          errorBorderColor: const Color(0xFFb03c3c),
          selectedColor: Styles.accentColor,
          selectedFillColor: Styles.secondaryColor,
          activeFillColor: Styles.secondaryColor,
          activeColor: Styles.accentColor2,
          inactiveFillColor: Styles.secondaryColor,
          inactiveColor: Styles.accentColor2,
        ),
        cursorColor: Styles.textColor,
        animationDuration: const Duration(milliseconds: 100),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: otpTextController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          debugPrint(value);
          setState(() {
            currentText = value;
          });
        },
      ),
      // const Gap(8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tidak menerima kode?"),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            onPressed: resendOTP,
            child: Text("Kirim ulang $_resendTimer"),
          ),
        ],
      ),
      const Gap(20),
      NextButton(
        onPressed: () {
          // if (_registerForm2Key.currentState!.validate()) {
          //   // If the form is valid, display a snackbar. In the real world,
          //   // you'd often call a server or save the information in a database.
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Mengecek Kode OTP')),
          //   );
          //   Future.delayed(const Duration(seconds: 1), () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return ForgotPasswordNewPwView(email: _email);
          //     }));
          //   });
          // }
          onNext();
        },
      ),
      const Gap(8),
    ];
  }

  void onNext() async {
    if (_registerForm2Key.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      // Menampilkan animasi loading
      setState(() {
        registerController.isLoading = true;
      });

      try {
        // Memproses API
        final response = await Future.any([
          registerController.verifyOTP(_email, otpTextController.text),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        setState(() {
          registerController.isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mengecek Kode OTP')),
        );

        // Menampilkan pesan status autentikasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        // Jika status autentikasi sukses dengan kode 0
        if (response.code == 0) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ForgotPasswordNewPwView(email: _email);
            }));
          });
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan dari controller
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger(printer: PrettyPrinter()).e(err);
      }
    }
  }
}
