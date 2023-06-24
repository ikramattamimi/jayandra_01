// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/module/register/register_controller.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/view/register/register_elclass_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterOTPView extends StatefulWidget {
  const RegisterOTPView({super.key, required this.email});
  final String email;

  @override
  State<RegisterOTPView> createState() => _RegisterOTPViewState();
}

class _RegisterOTPViewState extends State<RegisterOTPView> {
  final _registerForm2Key = GlobalKey<FormState>();
  late String email;
  final registerController = RegisterController();

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Daftar",
      subtitle: "Masukkan Kode OTP yang sudah dikirimkan ke email",
      form: Form(
        key: _registerForm2Key,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
    email = widget.email;
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
      (!registerController.isLoading)
          ? NextButton(
              onPressed: () {
                onNext();
              },
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
          registerController.verifyOTP(email, otpTextController.text),
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
            context.pushNamed(
              "register_page_3",
              queryParams: {
                "email": email,
              },
            );
          });
        }
      } catch (err) {
        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan dari controller
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );

        Logger(printer: PrettyPrinter()).e(err);
      }
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _resendTimer = '($_start' 'd)';
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
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
      }
    });
  }

  void resendOTP() async {
    if (!_isButtonDisabled) {
      try {
        // Memproses API cek email
        final response = await Future.any([
          registerController.sendOTP(email),
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
}
