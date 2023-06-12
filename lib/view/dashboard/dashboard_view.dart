import 'package:carbon_icons/carbon_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:jayandra_01/view/report/report_widget.dart';
import 'package:jayandra_01/services/notification_service.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/utils/connectivity.dart';
import 'package:jayandra_01/custom_widget/powerstrip_view.dart';
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
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final powerstripProvider = Provider.of<PowerstripProvider>(context);

    // initWidgets(userModel, powerstripProvider);
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
                            print('Cancel all tasks completed');
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
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Perangkat Anda",
              style: Styles.headingStyle2,
              textAlign: TextAlign.start,
            ),
          ),
          const Gap(24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _getPowerstripWidget(powerstrips)),
          ),
          // AnimatedCard(),
        ],
      ),
    );
  }

  List<Widget> _getPowerstripWidget(List<PowerstripModel> powerstrips) {
    if (powerstrips != []) {
      _powerstripWidgets = [];
      for (var powerstrip in powerstrips) {
        // print(powerstrip.totalActiveSocket);
        _powerstripWidgets!.add(
          PowerstripView(
            powerstripId: powerstrip.id,
            // powerstripIcon: Icons.bed,
            // powerstrip: powerstrip,
          ),
        );
      }
    }
    return _powerstripWidgets!;
  }

  String? userName;
  // final _controller = PowerstripController();
  // List<PowerstripModel>? _powerstrips = [];
  List<Widget>? _powerstripWidgets = [];

  /// Response pemanggilan API yang sudah dalam bentuk objek [PowerstripResponse]
  // late PowerstripResponse? _powerstripObjectResponse;

  @override
  void initState() {
    // TODO: implement initState
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
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Styles.secondaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(color: Styles.accentColor),
            ),
          ),
        ),
      ];
    }
  }

  /// Mengambil data powerstrip
  ///
  /// Jika data powerstrip berhasil didapat ketika login data akan
  /// diambil dari [SharedPreferences].
  ///
  /// Sebaliknya, data powerstrip akan diambil dengan melakukan pemanggilan
  /// API getPowerstrip pada [LoginController]
  // void _getPowerstrip() async {
  //   try {
  //     _powerstripObjectResponse = await _controller.getPowerstrip().then((value) {
  //       setState(() {
  //         if (value!.data != null) {
  //           _powerstrips = value.data;
  //         } else {
  //           _powerstrips = null;
  //           _powerstripWidgets = [
  //             SizedBox(
  //               height: 50,
  //               width: MediaQuery.of(context).size.width,
  //               child: Center(
  //                 child: Text(
  //                   "Belum ada perangkat",
  //                   style: Styles.bodyTextBlack,
  //                 ),
  //               ),
  //             ),
  //           ];
  //         }
  //         _getPowerstripWidget();
  //       });
  //       return null;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

void getNotification() {
  print("Get Notification");
  NotificationService().showNotification(title: "Halo", body: "Bjirr");
}
