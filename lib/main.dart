import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_page.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_register_page.dart';
import 'package:jayandra_01/page/login/landing_page.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/register/register_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/page/register/register_page_2.dart';
import 'package:jayandra_01/page/register/register_page_3.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Styles.accentColor,
          secondary: Styles.accentColor2,
        ),
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        name: "main_page",
        builder: (BuildContext context, GoRouterState state) => const MainScreen(),
        routes: <GoRoute>[
          // Main Page Route
          GoRoute(
            path: "page2",
            name: "add_device",
            builder: (BuildContext context, GoRouterState state) => const AddDevice(),
          ),
          GoRoute(
            path: "about",
            name: "about_page",
            builder: (BuildContext context, GoRouterState state) => const AboutPage(),
          ),
          GoRoute(
            path: "electricity_class",
            name: "electricity_class_page",
            builder: (BuildContext context, GoRouterState state) => const ElectricityClassPage(),
          ),

          // Landing Page Route
          GoRoute(
            path: "landing_page",
            name: "landing_page",
            builder: (BuildContext context, GoRouterState state) => const LandingPage(),
            routes: <GoRoute>[
              GoRoute(
                path: "login_page",
                name: "login_page",
                builder: (BuildContext context, GoRouterState state) => const LoginPage(),
              ),

              // Register Page
              GoRoute(
                path: "register_page",
                name: "register_page",
                builder: (BuildContext context, GoRouterState state) => const RegisterPage1(),
                routes: <GoRoute>[
                  GoRoute(
                    path: "register_page_2",
                    name: "register_page_2",
                    builder: (BuildContext context, GoRouterState state) => const RegisterPage2(),
                    routes: <GoRoute>[
                      GoRoute(path: "register_page_3", name: "register_page_3", builder: (BuildContext context, GoRouterState state) => const RegisterPage3(), routes: <GoRoute>[
                        GoRoute(
                          path: "electricity_class_register_page",
                          name: "electricity_class_register_page",
                          builder: (BuildContext context, GoRouterState state) => const ElectricityClassRegisterPage(),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
