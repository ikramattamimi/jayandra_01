import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:gap/gap.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_controller.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/view/powerstrip/home_view/home_widget.dart';
import 'package:jayandra_01/view/report/report_widget.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:jayandra_01/models/init_models.dart';

/// Widget ini menampilkan halaman Dashboard
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    final homeProvider = Provider.of<HomeProvider>(context);
    var homes = homeProvider.homes;

    final userProvider = Provider.of<UserModel>(context, listen: false);
    final powerstripProvider = Provider.of<PowerstripProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    // final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    initModels(
      userProvider: userProvider,
      powerstripProvider: powerstripProvider,
      timerProvider: timerProvider,
      scheduleProvider: scheduleProvider,
      homeProvider: homeProvider,
      reportProvider: reportProvider,
    );
    for (var home in homes) {
      getLimit(home.homeId, home.homeName);
    }

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
                  "Rumah Anda",
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
            child: Row(children: getHomeWidgets(homes)),
          ),
        ],
      ),
    );
  }

  String? userName;

  @override
  void initState() {
    super.initState();
    ConnectivityStatus.checkConnectivityState();
  }

  List<Widget> getHomeWidgets(List<HomeModel> homes) {
    List<Widget> homeWidgets = [];
    // homes.add(const HomeWidget());

    for (var home in homes) {
      homeWidgets.add(HomeWidget(
        homeModel: home,
      ));
    }
    return homeWidgets;
  }

  getLimit(int homeId, String homeName) async {
    var now = DateTime.now();

    HomeController homeController = HomeController();
    var limit = await homeController.getLimit(homeId);

    if (now.hour < 12) {
      AndroidAlarmManager.oneShotAt(
        DateTime(now.year, now.month, now.day, 12, 0),
        120 + homeId,
        setLimitNotification,
        params: {
          'homeId' : homeId,
          'limit': limit.toInt(),
          'homeName': homeName,
          // 'timerId': newTimer.timerId,
        },
      );
    }
  }
}

setLimitNotification(int idTimer, Map<String, dynamic> home) async {

  NotificationService().showNotification(
    id: home['homeId'],
    title: "Pengingat penggunaan listrik ${home['homeName']}",
    body: "Penggunaan sudah mencapai ${home['limit']}% dari batas budgeting!",
  );
}
