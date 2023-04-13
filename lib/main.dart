import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_page.dart';
import 'package:jayandra_01/screens/about_page.dart';
import 'package:jayandra_01/screens/add_device_screen.dart';
import 'package:jayandra_01/screens/bottom_bar.dart';
import 'package:jayandra_01/screens/main_screen.dart';
import 'package:jayandra_01/utils/app_styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String title = "Jayandra";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Styles.primaryColor,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        name: "main_page",
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: "page2",
            name: "add_device",
            builder: (BuildContext context, GoRouterState state) =>
                const AddDevice(),
          ),
          GoRoute(
            path: "about",
            name: "about_page",
            builder: (BuildContext context, GoRouterState state) =>
                const AboutPage(),
          ),
          GoRoute(
            path: "electricity_class",
            name: "electricity_class_page",
            builder: (BuildContext context, GoRouterState state) =>
                const ElectricityClassPage(),
          ),
        ],
      ),
    ],
  );
}
