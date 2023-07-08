import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/list_tile_view.dart';
import 'package:jayandra_01/custom_widget/white_container.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({super.key, required this.notifyParent});
  final Function notifyParent;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  // String? userName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final size = AppLayout.getSize(context);
    var userProvider = Provider.of<UserModel>(context);
    var userName = userProvider.name;

    final powerstripProvider = Provider.of<PowerstripProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===================================
                // Page Title
                // ===================================
                Text(
                  "Profil",
                  style: Styles.headingStyle1,
                ),
                const Gap(32),
                // ===================================
                // User Profile
                // ===================================
                WhiteContainer(
                  borderColor: Styles.textColor2,
                  margin: 0,
                  padding: 0,
                  child: ListTile(
                    leading: Icon(
                      CarbonIcons.user_avatar_filled,
                      size: 30,
                      color: Styles.accentColor,
                    ),
                    title: Text(
                      userName,
                      style: Styles.title,
                    ),
                    trailing: Text(
                      "Ubah",
                      style: Styles.buttonTextBlue,
                    ),
                    onTap: () {
                      context.pushNamed("edit_profile");
                    },
                    // color
                  ),
                ),
                const Gap(16),
                // ===================================
                // Account Section
                // ===================================
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Akun",
                    style: Styles.title,
                  ),
                ),
                const Gap(16),
                Container(
                  decoration: BoxDecoration(
                    color: Styles.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // CustomListTile(
                      //   icon: Icons.money,
                      //   title: "Golongan Listrik",
                      //   onTap: () {
                      //     context.pushNamed("electricity_class_page");
                      //   },
                      // ),
                      CustomListTile(
                        icon: Icons.logout_rounded,
                        title: "Keluar",
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                'Log Out',
                                style: Styles.headingStyle1,
                              ),
                              content: Text(
                                'Apakah Anda yakin ingin keluar?',
                                style: Styles.bodyTextBlack,
                              ),
                              actions: <Widget>[
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences.getInstance();
                                          prefs.clear();
                                          // ignore: use_build_context_synchronously
                                          context.pushReplacementNamed("landing_page");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Styles.accentColor,
                                          minimumSize: const Size(50, 50),
                                        ),
                                        child: Text(
                                          "Oke".toUpperCase(),
                                          style: Styles.buttonTextWhite,
                                        ),
                                      ),
                                      const Gap(8),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Batalkan'),
                                        style: TextButton.styleFrom(
                                          minimumSize: const Size(50, 50),
                                        ),
                                        child: Text(
                                          'Batal'.toUpperCase(),
                                          style: Styles.buttonTextBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // ===================================
                // Other section
                // ===================================
                const Gap(16),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Lainnya",
                    style: Styles.title,
                  ),
                ),
                const Gap(16),
                Container(
                  decoration: BoxDecoration(
                    color: Styles.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CustomListTile(
                        icon: Icons.info_outline_rounded,
                        title: "Tentang Aplikasi",
                        onTap: () {
                          context.pushNamed("about_page");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
