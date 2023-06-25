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
      var homes = homeProvider.homes;
      for (var home in homes) {
        powerstripProvider.initializeData(userProvider.email, home.homeName).then((value) {
          // For get timer
          for (var powerstrip in powerstripProvider.powerstrips) {
            timerProvider.setPowerstrip = powerstrip;
            timerProvider.initializeData();

            scheduleProvider.setPowerstrip = powerstrip;
            scheduleProvider.initializeData();

            reportProvider.initializeData(home.homeName, powerstrip.pwsKey, userProvider.email);
          }
        });
      }
    }
    // return powerstripProvider.powerstrips;
  }
}
