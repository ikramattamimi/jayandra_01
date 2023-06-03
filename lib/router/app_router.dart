import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/page/add_device/add_device_page.dart';
import 'package:jayandra_01/page/add_device/adding_device.dart';
import 'package:jayandra_01/page/add_device/confirm_pairing.dart';
import 'package:jayandra_01/page/add_device/done_add_device.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_page.dart';
import 'package:jayandra_01/page/golongan_listrik/electricity_class_register_page.dart';
import 'package:jayandra_01/page/login/landing_page.dart';
import 'package:jayandra_01/page/login/login_page.dart';
import 'package:jayandra_01/page/profile/edit_profile_page.dart';
import 'package:jayandra_01/page/register/register_page_1.dart';
import 'package:jayandra_01/page/register/register_page_2.dart';
import 'package:jayandra_01/page/register/register_page_3.dart';
import 'package:jayandra_01/page/terminal/schedule/add_schedule_page.dart';
import 'package:jayandra_01/page/terminal/timer/add_timer_page.dart';
import 'package:jayandra_01/page/terminal/timer/edit_timer_page.dart';
import 'package:jayandra_01/page/terminal/schedule/schedule_page.dart';
import 'package:jayandra_01/page/terminal/terminal_page.dart';
import 'package:jayandra_01/page/terminal/timer/timer_page.dart';
import 'package:jayandra_01/screens/about_page.dart';
import 'package:jayandra_01/screens/main_screen.dart';

class AppRouter {
  GoRouter getRouter() {
    return _router;
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/splash",
        name: "splash_screen",
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),

      // LANDING PAGE ROUTE
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

          // REGISTER PAGE ROUTE
          GoRoute(
            path: "register_page",
            name: "register_page",
            builder: (BuildContext context, GoRouterState state) => const RegisterPage1(),
          ),
          GoRoute(
            path: "register_page_2",
            name: "register_page_2",
            builder: (BuildContext context, GoRouterState state) => const RegisterPage2(
              email: "ikram@gmail.com",
            ),
          ),
          GoRoute(
            path: "register_page_3",
            name: "register_page_3",
            builder: (BuildContext context, GoRouterState state) => const RegisterPage3(
              email: '',
            ),
          ),
          GoRoute(
            path: "electricity_class_register_page",
            name: "electricity_class_register_page",
            builder: (BuildContext context, GoRouterState state) => const ElectricityClassRegisterPage(),
          ),
        ],
      ),

      // MAIN PAGE ROUTE
      GoRoute(
        path: "/",
        name: "main_page",
        builder: (BuildContext context, GoRouterState state) => MainScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: "edit_profile",
            name: "edit_profile",
            builder: (BuildContext context, GoRouterState state) => const EditProfilePage(),
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
          // TERMINAL PAGE ROUTE
          GoRoute(
            path: "terminal",
            name: "terminal",
            builder: (BuildContext context, GoRouterState state) => TerminalPage(
              idTerminal: state.extra as int,
              // terminal: state.extra as TerminalModel,
            ),
          ),
          GoRoute(
            path: "schedule",
            name: "terminal_schedule",
            builder: (BuildContext context, GoRouterState state) => SchedulePage(terminal: state.extra as TerminalModel,),
          ),
          GoRoute(
            path: "add_schedule",
            name: "terminal_schedule_add",
            builder: (BuildContext context, GoRouterState state) => AddSchedulePage(terminal: state.extra as TerminalModel,),
          ),
          GoRoute(
            path: "timer",
            name: "terminal_timer",
            builder: (BuildContext context, GoRouterState state) => TimerPage(
              terminal: state.extra as TerminalModel,
            ),
          ),
          GoRoute(
            path: "add_timer",
            name: "terminal_timer_add",
            builder: (BuildContext context, GoRouterState state) => AddTimerPage(terminal: state.extra as TerminalModel),
          ),
          GoRoute(
            path: "edit_timer",
            name: "terminal_timer_edit",
            builder: (BuildContext context, GoRouterState state) => EditTimerPage(
              terminalTimer: state.extra as TerminalTimer,
            ),
          ),

          // ADD DEVICE PAGE ROUTE
          GoRoute(
            path: "add_device",
            name: "add_device",
            builder: (BuildContext context, GoRouterState state) => const AddDevicePage(),
          ),
          GoRoute(
            path: "confirm_pairing",
            name: "confirm_pairing",
            builder: (BuildContext context, GoRouterState state) => const ConfirmPairingPage(),
          ),
          GoRoute(
            path: "adding_device",
            name: "adding_device",
            builder: (BuildContext context, GoRouterState state) => const AddingDevicePage(),
          ),
          GoRoute(
            path: "done_add_device",
            name: "done_add_device",
            builder: (BuildContext context, GoRouterState state) => const DoneAddDevice(),
          ),
        ],
      ),
    ],
    initialLocation: '/splash',
    // initialLocation: '/',
    debugLogDiagnostics: true,
    routerNeglect: true,
  );
}
