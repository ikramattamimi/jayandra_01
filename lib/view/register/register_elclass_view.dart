import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/view/register/register_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/view/register/register_identity_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class RegisterPage3 extends StatefulWidget {
  const RegisterPage3({super.key, required this.email});
  final String email;

  @override
  State<RegisterPage3> createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  final _registerForm3Key = GlobalKey<FormState>();
  late String _email;

  String? electricityClass;

  var description =
      "Golongan Listrik merupakan tarif tenaga listrik yang disediakan oleh PT Perusahaan Listrik Negara (Persero) kepada konsumen. Anda dapat mengetahui golongan listrik yang terpasang di rumah Anda melalui struk tagihan listrik.";
  var electricityClassData = [
    {
      'nama': 'R1 / 900 VA',
      'biaya': 1352.00,
    },
    {
      'nama': 'R1 / 1.300 VA - 2.200 VA',
      'biaya': 1444.70,
    },
    {
      'nama': 'R2 / 3.500 VA - 5.500 VA',
      'biaya': 1699.53,
    },
    {
      'nama': 'R3 / 6.600 VA ke atas',
      'biaya': 1699.53,
    },
  ];

  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterElectricityClassView(
      title: "Daftar",
      subtitle: "Masukkan Golongan Listrik Anda",
      form: Form(
        key: _registerForm3Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getRegisterFormWidget,
        ),
      ),
    );
  }

  void selectRadio(value) {
    setState(() {
      electricityClass = value.toString();
    });
  }

  List<Widget> get _getRegisterFormWidget {
    return [
      Text(
        description,
        style: Styles.bodyTextBlack2,
        textAlign: TextAlign.justify,
      ),
      const Gap(16),
      Text(
        "Silahkan pilih golongan listrik anda:",
        style: Styles.bodyTextBlack2,
      ),
      const Gap(8),
      Column(
        children: electricityClassData.map((items) {
          return RadioListTile(
            title: Text(
              items['nama'].toString(),
              style: Styles.bodyTextBlack2,
            ),
            value: items['nama'].toString(),
            groupValue: electricityClass,
            onChanged: (value) {
              selectRadio(value);
            },
          );
        }).toList(),
      ),
      NextButton(
        onPressed: () {
          if (_registerForm3Key.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Mengecek Kode OTP')),
            // );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RegisterIdentityView(
                  email: _email,
                  // electricityClass: electricityClass.toString(),
                );
              }));
            });
          }
        },
      ),
      const Gap(8),
    ];
  }
}
