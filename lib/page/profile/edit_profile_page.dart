import 'package:flutter/material.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
      body: SafeArea(
          child: WhiteContainer(
        padding: 16,
        margin: 16,
        child: Column(
          children: [
            Text("User"),
          ],
        ),
      )),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column()
    
    );
  }
}