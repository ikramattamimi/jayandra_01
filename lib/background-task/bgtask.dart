import 'package:flutter/material.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_repository.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var powerstripRepository = PowerstripRepository();

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "changeSocketStatusTimer":
        logger.i("Panggil setSocketStatus");
        logger.i(inputData);
        try {
          await powerstripRepository.setSocketStatus(
            inputData?['socketId'],
            inputData?['powerstripId'],
            inputData?['status'],
          );

          // PowerstripProvider.instance.updateOneSocketStatus(
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
