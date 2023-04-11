import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/list_tile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Container(
                  decoration: BoxDecoration(
                      color: Styles.secondaryColor,
                      border: Border.all(
                        color: Styles.textColor2,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      CarbonIcons.user_avatar_filled,
                      size: 30,
                      color: Styles.accentColor,
                    ),
                    title: Text(
                      "Lisa Lasagna",
                      style: Styles.title,
                    ),
                    trailing: Text(
                      "Ubah",
                      style: Styles.button,
                    ),
                    onTap: () {
                      context.goNamed("add_device");
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
                        onTap: () {},
                      ),
                      CustomListTile(
                        icon: Icons.logout_rounded,
                        title: "Keluar",
                        onTap: () {},
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
                          context.goNamed("about_page");
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
