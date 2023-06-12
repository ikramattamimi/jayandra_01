import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);
    return Form(
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
            ),
            const Gap(16),
            PasswordTextForm(
              formKey: _editProfileFormKey,
              hintText: "Password",
            ),
            const Gap(16),
            PasswordTextForm(
              formKey: _editProfileFormKey,
              hintText: "Ulangi Password",
            ),
            const Gap(32),
            CustomElevatedButton(
              backgroundColor: Styles.accentColor,
              borderColor: Colors.transparent,
              text: "Simpan",
              textStyle: Styles.buttonTextWhite,
              onPressed: () {
                user.setUserName(_nameController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
