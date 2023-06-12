import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/view/login/custom_container.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/circle_icon_container.dart';
import 'package:jayandra_01/custom_widget/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _LandingPageState();
}

class _LandingPageState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _myContext = context;
    // final userModel = Provider.of<UserModel>(_myContext, listen: false);
    // final powerstripProvider = Provider.of<PowerstripProvider>(_myContext, listen: false);
    // initWidgets(userModel, powerstripProvider);
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isUserLoggedIn = prefs.getBool('isUserLoggedIn');

    // prefs.clear();

    // final userModel = Provider.of<UserModel>(context, listen: false);

    // Biar powerstrip auto refresh
    prefs.remove('powerstrip');

    Timer(const Duration(seconds: 2), (() {
      if (isUserLoggedIn != null && isUserLoggedIn) {
        context.pushReplacementNamed('main_page');
      } else {
        context.pushReplacementNamed('landing_page');
      }
    }));
  }

  void initWidgets(UserModel userModel, PowerstripProvider powerstripProvider) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isUserLoggedIn') ?? false) {
      UserModel user = UserModel(
        id: prefs.getInt('user_id')!,
        name: prefs.getString('user_name')!,
        email: prefs.getString('email')!,
        electricityclass: prefs.getString('electricityclass')!,
      );

      userModel.updateUser(user);

      powerstripProvider.initializeData(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userModel = Provider.of<UserModel>(context);
    // final powerstripProvider = Provider.of<PowerstripProvider>(context);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.accentColor,
      body: SafeArea(
        child: CustomContainer(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jayandra Powerstrip",
              style: Styles.headingStyleWhite1,
            ),
            Expanded(
              child: Center(
                child: CircleIconContainer(
                  width: 70,
                  height: 70,
                  color: Styles.secondaryColor,
                  icon: Icons.electric_bolt_rounded,
                  iconSize: 50,
                  iconColor: Styles.accentColor,
                ),
              ),
            ),
            // Text(
            //   "Pantau dan Kendalikan",
            //   style: Styles.headingStyleWhite2,
            // ),
            // const Gap(8),
            // Text(
            //   "Pantau penggunaan listrik dan kendalikan powerstrip dari Jayandra Powerstrip",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w200,
            //     color: Styles.secondaryColor,
            //     fontSize: 14,
            //   ),
            // ),
            // const Gap(32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomElevatedButton(
                  backgroundColor: Styles.secondaryColor,
                  borderColor: Styles.secondaryColor,
                  text: "masuk",
                  textStyle: Styles.buttonTextBlue,
                  onPressed: () {
                    context.pushNamed("login_page");
                  },
                ),
                const Gap(10),
                CustomElevatedButton(
                  backgroundColor: Styles.accentColor,
                  borderColor: Styles.secondaryColor,
                  text: "Daftar",
                  textStyle: Styles.buttonTextWhite,
                  onPressed: () {
                    context.pushNamed("register_page");
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
