import 'dart:async';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/user/user_controller.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:jayandra_01/utils/form_regex.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Profil",
          style: Styles.bodyTextBlack,
        ),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Styles.secondaryColor,
        foregroundColor: Styles.textColor,
      ),
      body: ListView(
        children: const [
          Card(
            margin: EdgeInsets.all(16),
            elevation: 0,
            child: EditProfileForm(),
          )
        ],
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _editProfileFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userController = UserController();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);
    _nameController.text = user.name;
    return Form(
      key: _editProfileFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(32),
            Icon(
              CarbonIcons.user_avatar_filled,
              color: Styles.accentColor,
              size: 80,
            ),
            const Gap(32),
            CustomTextFormField(
              formKey: _editProfileFormKey,
              controller: _nameController,
              prefixIcon: CarbonIcons.user_avatar_filled,
              hintText: user.name,
              obscureText: false,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (!value!.isValidName) {
                  return 'Nama tidak valid';
                } else {
                  _editProfileFormKey.currentState?.save();
                  return null;
                }
              },
            ),
            const Gap(16),
            // PasswordTextForm(
            //   formKey: _editProfileFormKey,
            //   hintText: "Password",
            // ),
            // const Gap(16),
            // PasswordTextForm(
            //   formKey: _editProfileFormKey,
            //   hintText: "Ulangi Password",
            // ),
            // const Gap(32),
            CustomElevatedButton(
              backgroundColor: Styles.accentColor,
              borderColor: Colors.transparent,
              text: "Simpan",
              textStyle: Styles.buttonTextWhite,
              onPressed: () {
                user.setUserName(_nameController.text);
                updateName(user.email, _nameController.text);
              },
            )
          ],
        ),
      ),
    );
  }

  void updateName(String email, String name) async {
    var prefs = await SharedPreferences.getInstance();
    // Jika validasi form berhasil
    if (_editProfileFormKey.currentState!.validate()) {
      // // Menampilkan animasi loading
      // setState(() {
      //   _nameController.isLoading = true;
      // });

      try {
        // Memproses API
        final changeNameResponse = await Future.any([
          _userController.changeName(email, name),
          Future.delayed(
            const Duration(seconds: 10),
            () => throw TimeoutException('API call took too long'),
          ),
        ]);

        // Menyembunyikan animasi loading
        // setState(() {
        //   _loginController.isLoading = false;
        // });

        // Menampilkan pesan status autentikasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(changeNameResponse.message)),
        );

        // Jika status autentikasi sukses dengan kode 0
        if (changeNameResponse.code == 0) {
          prefs.setString('user_name', name);
          context.pop();
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
