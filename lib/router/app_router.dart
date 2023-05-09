import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_page.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_register_page.dart';
import 'package:jayandra_01/page/login/landing_page.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/profile/edit_profile_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/page/register/register_page_2.dart';
import 'package:jayandra_01/page/register/register_page_3.dart';
import 'package:jayandra_01/page/terminal/add_schedule_page.dart';
import 'package:jayandra_01/page/terminal/add_timer_page.dart';
import 'package:jayandra_01/page/terminal/schedule_page.dart';
import 'package:jayandra_01/page/terminal/terminal_page.dart';
import 'package:jayandra_01/page/terminal/timer_page.dart';
import 'package:jayandra_01/screens/about_page.dart';
import 'package:jayandra_01/screens/add_device_screen.dart';
import 'package:jayandra_01/screens/main_screen.dart';

class AppRouter {
  GoRouter getRouter() {
    return _router;
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      // Landing Page Route
      GoRoute(
        path: "/landing_page",
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
      GoRoute(
        path: "/",
        name: "main_page",
        builder: (BuildContext context, GoRouterState state) => const MainScreen(),
        routes: <GoRoute>[
          // Main Page Route
          GoRoute(
            path: "edit_profile",
            name: "edit_profile",
            builder: (BuildContext context, GoRouterState state) => const EditProfilePage(),
          ),
          GoRoute(
            path: "terminal/1",
            name: "terminal_1",
            builder: (BuildContext context, GoRouterState state) => const TerminalPage(),
            routes: <GoRoute>[
              GoRoute(
                path: "terminal/1/schedule",
                name: "terminal_schedule",
                builder: (BuildContext context, GoRouterState state) => const SchedulePage(),
                routes: <GoRoute>[
                  GoRoute(
                    path: "terminal/1/schedule/add",
                    name: "terminal_schedule_add",
                    builder: (BuildContext context, GoRouterState state) => const AddSchedulePage(),
                  )
                ],
              ),
              GoRoute(
                path: "terminal/1/timer",
                name: "terminal_timer",
                builder: (BuildContext context, GoRouterState state) => const TimerPage(),
                routes: <GoRoute>[
                  GoRoute(
                    path: "terminal/1/timer/add",
                    name: "terminal_timer_add",
                    builder: (BuildContext context, GoRouterState state) => const AddTimerPage(),
                  )
                ],
              ),
            ],
          ),
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
        ],
      ),
    ],
    initialLocation: '/landing_page',
    // initialLocation: '/',
    debugLogDiagnostics: true,
    routerNeglect: true,
  );
}
