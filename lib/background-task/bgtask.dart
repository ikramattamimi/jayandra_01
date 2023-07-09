import 'package:flutter/material.dart';
import 'package:jayandra_01/models/socket_model.dart';
// import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/powerstrip/socket_controller.dart';
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

  var socketController = SocketController();

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "changeSocketStatusTimer":
        try {
          var socket = SocketModel(
            pwsKey: inputData?['pwsKey'],
            socketNr: inputData?['socketId'],
            status: inputData?['status'],
          );

          await socketController.setSocketStatus(socket).then((value) {
            Logger().i(value!.message);
          });
        } catch (err) {
          logger.e(err);
        }
        break;
      case "changeSocketStatusSchedule":
        try {
          var socket = SocketModel(
            pwsKey: inputData?['pwsKey'],
            socketNr: inputData?['socketId'],
            status: inputData?['status'],
          );
          await socketController.setSocketStatus(socket);
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
