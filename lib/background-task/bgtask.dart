import 'package:flutter/material.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/module/terminal/terminal_provider.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var terminalRepository = TerminalRepository();

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "simpleTask":
        // try {
        print("==========================================="); //simpleTask will be emitted here.
        logger.i("Native called background task: "); //simpleTask will be emitted here.
        // } catch (err) {
        //   logger.e(err.toString()); // Logger flutter package, prints error on the debug console
        //   throw Exception(err);
        // }
        break;
      case "anjay":
        logger.d("message");
        break;
      case "changeSocketStatusTimer":
        logger.i("Panggil setSocketStatus");
        logger.i(inputData);
        try {
          await terminalRepository.setSocketStatus(
            inputData?['socketId'],
            inputData?['terminalId'],
            inputData?['status'],
          );

          // TerminalProvider.instance.updateOneSocketStatus(
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
