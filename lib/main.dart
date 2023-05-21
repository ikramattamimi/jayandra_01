import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayandra_01/router/app_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String title = "Jayandra";
  final AppRouter _appRouter = AppRouter();
  late GoRouter _router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Styles.primaryColor,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _router = _appRouter.getRouter();
    return MaterialApp.router(
      routerConfig: _router,
      // routerDelegate: _router.routerDelegate,
      // routeInformationParser: _router.routeInformationParser,
      // routeInformationProvider: _router.routeInformationProvider,
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
