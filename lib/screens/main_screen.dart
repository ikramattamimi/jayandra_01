import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/services.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/page/dashboard/dashboard_page.dart';
import 'package:jayandra_01/screens/profile_screen.dart';
import 'package:jayandra_01/page/report/report_screen.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  // final User user;
  // MainScreen({super.key, required this.user});
  MainScreen({super.key});
  User user1 = User(id: 123, name: "Ikram", email: "ikramikram@gmail.com", electricityclass: "");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      home: BottomBar(
        // user: user1,
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  // final User user;
  // const BottomBar({super.key, required this.user});
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  late String userName;
  late User user;
  List<Widget> _widgetoptions = <Widget>[
      // DashboardPage(user: user1),
      DashboardPage(),
      ReportScreen(),
      ProfileScreen(),
    ];

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name').toString();
    });
    // user = widget.user;
    User user1 = User(id: 123, name: "Ikram", email: "ikramikram@gmail.com", electricityclass: "");

    _widgetoptions = <Widget>[
      // DashboardPage(user: user1),
      DashboardPage(),
      ReportScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Styles.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        // statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: Center(
        child: _widgetoptions[_selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Styles.secondaryColor,
          selectedItemColor: Styles.accentColor,
          unselectedItemColor: Styles.accentColor2,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CarbonIcons.report,
                ),
                label: "Report"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "User"),
          ],
        ),
      ),
    );
  }
}
