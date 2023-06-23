import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/schedule/schedule_provider.dart';
import 'package:jayandra_01/module/timer/timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initModels({
  required UserModel userProvider,
  required PowerstripProvider powerstripProvider,
  required TimerProvider timerProvider,
  required ScheduleProvider scheduleProvider,
  required HomeProvider homeProvider,
}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isUserLoggedIn') ?? false) {

    if (userProvider.email == "") {
      userProvider.updateUser(
        userId: prefs.getInt('user_id')!,
        name: prefs.getString('user_name')!,
        email: prefs.getString('email')!,
      );
    }

    if (homeProvider.homes.isEmpty) {
      homeProvider.initializeData(userProvider.userId);
    }

    if (powerstripProvider.powerstrips.isEmpty) {
      powerstripProvider.initializeData(userProvider.userId).then((value) {
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
