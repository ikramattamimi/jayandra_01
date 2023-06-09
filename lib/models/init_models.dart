import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/report/report_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initModels({
  required UserModel userProvider,
  required PowerstripProvider powerstripProvider,
  required TimerProvider timerProvider,
  required ScheduleProvider scheduleProvider,
  required HomeProvider homeProvider,
  required ReportProvider reportProvider,
}) async {
  Future.wait([
    callAllInit(
      userProvider: userProvider,
      powerstripProvider: powerstripProvider,
      timerProvider: timerProvider,
      scheduleProvider: scheduleProvider,
      homeProvider: homeProvider,
      reportProvider: reportProvider,
    ),
  ]);
}

void initModelsAlter({
  required UserModel userProvider,
  required PowerstripProvider powerstripProvider,
  required TimerProvider timerProvider,
  required ScheduleProvider scheduleProvider,
  required HomeProvider homeProvider,
  required ReportProvider reportProvider,
}) async {
  Future.wait([
    callAllInitAlter(
      userProvider: userProvider,
      powerstripProvider: powerstripProvider,
      timerProvider: timerProvider,
      scheduleProvider: scheduleProvider,
      homeProvider: homeProvider,
      reportProvider: reportProvider,
    ),
  ]);
}

Future<void> callAllInit({
  required UserModel userProvider,
  required PowerstripProvider powerstripProvider,
  required TimerProvider timerProvider,
  required ScheduleProvider scheduleProvider,
  required HomeProvider homeProvider,
  required ReportProvider reportProvider,
}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isUserLoggedIn') ?? false) {
    if (userProvider.email == "") {
      userProvider.updateUser(
        name: prefs.getString('user_name')!,
        email: prefs.getString('email')!,
      );
    }

    if (homeProvider.homes.isEmpty) {
      homeProvider.initializeData(userProvider.email);
    }

    if (powerstripProvider.powerstrips.isEmpty) {
      reportProvider.createReportDashboardModelsFromApi(userProvider.email);
      reportProvider.createReportAllModelsFromApi(userProvider.email);

      reportProvider.clearPwsReport();
      for (var home in homeProvider.homes) {
        reportProvider.createReportHomeModelsFromApi(userProvider.email, home.homeId);
        powerstripProvider.initializeData(home.homeId).then((value) {
          // For get timer
          for (var powerstrip in powerstripProvider.powerstrips.where((element) => element.homeId == home.homeId)) {
            timerProvider.setPowerstrip = powerstrip;
            timerProvider.initializeData();

            scheduleProvider.setPowerstrip = powerstrip;
            if (scheduleProvider.schedules.where((element) => element.pwsKey == powerstrip.pwsKey).isEmpty) {
              scheduleProvider.initializeData();
            }

            reportProvider.createReportPowerstripModelsFromApi(powerstrip.pwsKey);
          }
        });
      }
    }
    // return powerstripProvider.powerstrips;
  }
}


Future<void> callAllInitAlter({
  required UserModel userProvider,
  required PowerstripProvider powerstripProvider,
  required TimerProvider timerProvider,
  required ScheduleProvider scheduleProvider,
  required HomeProvider homeProvider,
  required ReportProvider reportProvider,
}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isUserLoggedIn') ?? false) {
    userProvider.updateUser(
      name: prefs.getString('user_name')!,
      email: prefs.getString('email')!,
    );

    homeProvider.initializeData(userProvider.email);

    reportProvider.createReportDashboardModelsFromApi(userProvider.email);
    reportProvider.createReportAllModelsFromApi(userProvider.email);

    reportProvider.clearPwsReport();
    for (var home in homeProvider.homes) {
      reportProvider.createReportHomeModelsFromApi(userProvider.email, home.homeId);
      powerstripProvider.initializeData(home.homeId).then((value) {
        // For get timer
        for (var powerstrip in powerstripProvider.powerstrips.where((element) => element.homeId == home.homeId)) {
          timerProvider.setPowerstrip = powerstrip;
          timerProvider.initializeData();

          scheduleProvider.setPowerstrip = powerstrip;

          scheduleProvider.initializeData();

          reportProvider.createReportPowerstripModelsFromApi(powerstrip.pwsKey);
        }
      });
    }

    // return powerstripProvider.powerstrips;
  }
}