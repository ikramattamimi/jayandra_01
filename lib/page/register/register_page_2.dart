import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/register/register_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/page/register/register_page_3.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/custom_elevated_button.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:jayandra_01/widget/custom_text_form_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key, required this.email});
  final String email;

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final _registerForm2Key = GlobalKey<FormState>();
  late String _email;

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
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

  void _submitForm() {
    final form = _registerForm2Key.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        // perform login with _email and _password
      }
    }
  }

  TextEditingController textEditingController = TextEditingController();
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
    print(_email);
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

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

  resendOTP() {
    if (!_isButtonDisabled) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengirimkan ulang Kode OTP ke email')),
      );
    }
    null;
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
          errorBorderColor: Color(0xFFb03c3c),
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
        controller: textEditingController,
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
          Text("Tidak menerima kode?"),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
            ),
            onPressed: resendOTP,
            child: Text("Kirim ulang $_resendTimer"),
          ),
        ],
      ),
      const Gap(20),
      NextButton(
        onPressed: () {
          if (_registerForm2Key.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengecek Kode OTP')),
            );
            Future.delayed(Duration(seconds: 1), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RegisterPage3(email: _email);
              }));
            });
          }
        },
      ),
      const Gap(8),
    ];
  }
}
