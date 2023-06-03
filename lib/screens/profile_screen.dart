import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/list_tile_view.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = AppLayout.getSize(context);
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
                      "$userName",
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
                      CustomListTile(
                        icon: Icons.money,
                        title: "Golongan Listrik",
                        onTap: () {
                          context.pushNamed("electricity_class_page");
                        },
                      ),
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
                                          context.pushNamed("landing_page");
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
