import 'package:flutter/material.dart';
// import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_repository.dart';
// import 'package:jayandra_01/module/timer/timer_repository.dart';
import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var powerstripRepository = PowerstripRepository();
  // var timerRepo = TimerRepository();

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "changeSocketStatusTimer":
        // final providerContainer = ProviderContainer();
        // var powerstripProvider = Provider.of<PowerstripProvider>(
        //   context,
        //   listen: false,
        // );

        try {
          await powerstripRepository.setSocketStatus(
            inputData?['socketId'],
            inputData?['pwsKey'],
            inputData?['status'],
          );
          // await timerRepo.deleteTimer(
          //   inputData?['timerId'],
          // );

          // TODO: Ganti Provider dengan Riverpod
          // powerstripProvider.setOneSocketStatus(
          //   inputData?['socketId'],
          //   inputData?['termminalId'],
          //   inputData?['status'],
          // );
        } catch (err) {
          logger.e(err);
        }
        break;
    }

    return Future.value(true);
  });
}

void cancel(String workName) async {
  await Workmanager().cancelByUniqueName(workName);
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  logger.i("Task Cancelled");
}
