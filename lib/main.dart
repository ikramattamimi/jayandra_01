import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayandra_01/background-task/bgtask.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/router/app_router.dart';
import 'package:jayandra_01/services/alarm_manager_service.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

// ignore: unused_element
final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  // Local Notification
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  AlarmManagerService().initAlarmManager();
  tz.initializeTimeZones();

  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  // Workmanager().registerOneOffTask("bebas", "simpleTask");
  // Workmanager().registerPeriodicTask

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimerProvider>(
          create: (context) => TimerProvider(),
        ),
        ChangeNotifierProvider<ScheduleProvider>(
          create: (context) => ScheduleProvider(),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider<PowerstripProvider>(
          create: (context) => PowerstripProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<ReportProvider>(
          create: (context) => ReportProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  static const String title = "Jayandra";
  final AppRouter _appRouter = AppRouter();

  late GoRouter _router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _router = _appRouter.getRouter();
    return MaterialApp.router(
      routerConfig: _router,
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
}
