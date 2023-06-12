import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/view/add_device/add_device_page.dart';
import 'package:jayandra_01/view/add_device/adding_device.dart';
import 'package:jayandra_01/view/add_device/confirm_pairing.dart';
import 'package:jayandra_01/view/add_device/done_add_device.dart';
import 'package:jayandra_01/view/forgot_password/forgot_pw_email.view.dart';
import 'package:jayandra_01/view/golongan_listrik/electricity_class_view.dart';
import 'package:jayandra_01/view/golongan_listrik/electricity_class_register_view.dart';
import 'package:jayandra_01/view/login/splash_screen.dart';
import 'package:jayandra_01/view/login/login_view.dart';
import 'package:jayandra_01/view/report/budgeting/budgeting_view.dart';
import 'package:jayandra_01/view/user/edit_profile_view.dart';
import 'package:jayandra_01/view/register/register_email_view.dart';
import 'package:jayandra_01/view/register/register_otp_view.dart';
import 'package:jayandra_01/view/register/register_elclass_view.dart';
import 'package:jayandra_01/view/powerstrip/schedule/add_schedule_view.dart';
import 'package:jayandra_01/view/powerstrip/timer/add_timer_view.dart';
import 'package:jayandra_01/view/powerstrip/timer/edit_timer_view.dart';
import 'package:jayandra_01/view/powerstrip/schedule/schedule_view.dart';
import 'package:jayandra_01/view/powerstrip/powerstrip_view.dart';
import 'package:jayandra_01/view/powerstrip/timer/timer_view.dart';
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
            builder: (BuildContext context, GoRouterState state) => const LoginView(),
          ),

          // REGISTER PAGE ROUTE
          GoRoute(
            path: "register_page",
            name: "register_page",
            builder: (BuildContext context, GoRouterState state) => const RegisterEmailView(),
          ),
          GoRoute(
            path: "register_page_2",
            name: "register_page_2",
            builder: (BuildContext context, GoRouterState state) => const RegisterOTPView(
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
            builder: (BuildContext context, GoRouterState state) => const ElectricityClassRegisterView(),
          ),

          // FORGOT PASSWORD PAGE ROUTE
          GoRoute(
            path: "forgot_password_page",
            name: "forgot_password_page",
            builder: (BuildContext context, GoRouterState state) => const ForgotPasswordEmailView(),
          ),
          GoRoute(
            path: "forgot_password_page2",
            name: "forgot_password_page2",
            builder: (BuildContext context, GoRouterState state) => const ForgotPasswordEmailView(),
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
            builder: (BuildContext context, GoRouterState state) => const EditProfileView(),
          ),
          GoRoute(
            path: "about",
            name: "about_page",
            builder: (BuildContext context, GoRouterState state) => const AboutPage(),
          ),
          GoRoute(
            path: "electricity_class",
            name: "electricity_class_page",
            builder: (BuildContext context, GoRouterState state) => const ElectricityClassView(),
          ),
          // TERMINAL PAGE ROUTE
          GoRoute(
            path: "powerstrip",
            name: "powerstrip",
            builder: (BuildContext context, GoRouterState state) => PowerstripView(
              idPowerstrip: state.extra as int,
              // powerstrip: state.extra as PowerstripModel,
            ),
          ),
          GoRoute(path: "budgeting", name: "budgeting_page", builder: (BuildContext context, GoRouterState state) => BudgetingView()),
          GoRoute(
            path: "schedule",
            name: "powerstrip_schedule",
            builder: (BuildContext context, GoRouterState state) => ScheduleView(
              powerstrip: state.extra as PowerstripModel,
            ),
          ),
          GoRoute(
            path: "add_schedule",
            name: "powerstrip_schedule_add",
            builder: (BuildContext context, GoRouterState state) => AddScheduleView(
              powerstrip: state.extra as PowerstripModel,
            ),
          ),
          GoRoute(
            path: "timer",
            name: "powerstrip_timer",
            builder: (BuildContext context, GoRouterState state) => TimerView(
              powerstrip: state.extra as PowerstripModel,
            ),
          ),
          GoRoute(
            path: "add_timer",
            name: "powerstrip_timer_add",
            builder: (BuildContext context, GoRouterState state) => AddTimerPage(powerstrip: state.extra as PowerstripModel),
          ),
          GoRoute(
            path: "edit_timer",
            name: "powerstrip_timer_edit",
            builder: (BuildContext context, GoRouterState state) => EditTimerView(
              powerstripTimer: state.extra as PowerstripTimer,
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
