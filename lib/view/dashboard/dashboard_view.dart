import 'package:carbon_icons/carbon_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/view/powerstrip/home_view/home_widget.dart';
import 'package:jayandra_01/view/report/report_widget.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/connectivity.dart';
import 'package:jayandra_01/view/powerstrip/powerstrip_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

/// Widget ini menampilkan halaman Dashboard
class DashboardView extends StatefulWidget {
  // final User user;
  // const DashboardPage({super.key, required this.user});
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    getUserName();
    _isPowerstripNull();
    ConnectivityStatus.checkConnectivityState();

    BuildContext myContext = context;

    // For get powerstrip
    final userModel = Provider.of<UserModel>(myContext, listen: false);
    final powerstripProvider = Provider.of<PowerstripProvider>(myContext, listen: false);
    final timerProvider = Provider.of<TimerProvider>(myContext, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(myContext, listen: false);
    initModels(userModel, powerstripProvider, timerProvider, scheduleProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final powerstripProvider = Provider.of<PowerstripProvider>(context);

    var powerstrips = powerstripProvider.powerstrips;

    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Halo ${userModel.name}!',
                      style: Styles.headingStyle1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await Workmanager().cancelAll();
                          },
                          icon: Icon(
                            Icons.notifications_rounded,
                            size: 30,
                            color: Styles.textColor3,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context.pushNamed('add_device'),
                          icon: Icon(
                            CarbonIcons.add_filled,
                            size: 30,
                            color: Styles.accentColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Gap(16),
                // ============== Laporan Penggunaan
                const ReportWidget(),
              ],
            ),
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Perangkat Anda",
                  style: Styles.headingStyle2,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "Selengkapnya",
                  style: Styles.buttonTextBlue,
                ),
              ],
            ),
          ),
          const Gap(24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // child: Row(children: _getPowerstripWidget(powerstrips)),
            child: Row(children: getHomeWidgets()),
          ),
        ],
      ),
    );
  }

  String? userName;
  List<Widget>? _powerstripWidgets = [];

  void initModels(UserModel userModel, PowerstripProvider powerstripProvider, TimerProvider timerProvider, ScheduleProvider scheduleProvider) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isUserLoggedIn') ?? false) {
      UserModel user = UserModel(
        id: prefs.getInt('user_id')!,
        name: prefs.getString('user_name')!,
        email: prefs.getString('email')!,
        electricityclass: prefs.getString('electricityclass')!,
      );
      if (userModel.email == "") {
        userModel.updateUser(user);
      }
      if (powerstripProvider.powerstrips.isEmpty) {
        powerstripProvider.initializeData(user.id).then((value) {
          // For get timer
          for (var powerstrip in powerstripProvider.powerstrips) {
            timerProvider.setPowerstrip = powerstrip;
            timerProvider.initializeData();

            scheduleProvider.setPowerstrip = powerstrip;
            scheduleProvider.initializeData();
          }
        });
      }
      // return powerstripProvider.powerstrips;
    }
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  void _isPowerstripNull() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('powerstrip') == null) {
      _powerstripWidgets = [
        SizedBox(
          height: 140,
          width: 170,
          child: Card(
            margin: const EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            child: Center(
              child: CircularProgressIndicator(color: Styles.accentColor),
            ),
          ),
        ),
      ];
    }
  }

  List<Widget> _getPowerstripWidget(List<PowerstripModel> powerstrips) {
    if (powerstrips != []) {
      _powerstripWidgets = [];
      for (var powerstrip in powerstrips) {
        _powerstripWidgets!.add(
          PowerstripWidget(
            powerstripId: powerstrip.id,
          ),
        );
      }
      final screenSize = AppLayout.getSize(context);

      _powerstripWidgets!.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 16,
          ),
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: screenSize.height / 4.9,
              width: screenSize.width / 2.2,
              child: Card(
                elevation: 0,
                child: Center(
                  child: Icon(
                    Icons.add_circle_rounded,
                    size: 60,
                    color: Styles.textColor2,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return _powerstripWidgets!;
  }

  List<Widget> getHomeWidgets() {
    List<Widget> homes = [];
    final screenSize = AppLayout.getSize(context);
    homes.add(const HomeWidget());
    homes.add(
      Padding(
        padding: const EdgeInsets.only(
          left: 16,
          bottom: 16,
        ),
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: screenSize.width / 2.5,
            height: screenSize.height / 5.5,
            child: Card(
              elevation: 0,
              child: Center(
                child: Icon(
                  Icons.add_circle_rounded,
                  size: 60,
                  color: Styles.textColor2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return homes;
  }
}
