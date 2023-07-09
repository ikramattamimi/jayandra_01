import 'package:flutter/material.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PowerstripProvider with ChangeNotifier {
  // final int _userId;
  List<PowerstripModel> _powerstrips = [];

  List<PowerstripModel> get powerstrips => _powerstrips;

  static final PowerstripProvider instance = PowerstripProvider._();
  PowerstripProvider._();

  final _powerstripController = PowerstripController();

  PowerstripProvider();

  void addPowerstrip(PowerstripModel powerstrip) {
    _powerstrips.add(powerstrip);
    notifyListeners();
  }

  void removePowerstrip(int index) {
    _powerstrips.removeAt(index);
    notifyListeners();
  }

  void emptyPowerstripAtHome(int homeId) {
    _powerstrips.removeWhere((element) => element.homeId == homeId);
  }

  Future<void> initializeData(int homeId) async {
    List<PowerstripModel> powerstripModels = await createPowerstripModelsFromApi(homeId);
    emptyPowerstripAtHome(homeId);
    _powerstrips.addAll(powerstripModels);
    notifyListeners();
  }

  Future<List<PowerstripModel>> createPowerstripModelsFromApi(int homeId) async {
    List<PowerstripModel> powerstripModels = [];
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      await _powerstripController.getPowerstrip(homeId).then((value) {
        for (var powerstrip in value!.data!) {
          powerstripModels.add(powerstrip);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      logger.e('Terjadi kesalahan koneksi: $e');
    }
    return powerstripModels;
  }

  void updatePowerstrips(List<PowerstripModel> powerstrips) {
    _powerstrips = powerstrips;
  }

  static PowerstripProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<PowerstripProvider>(context, listen: listen);
  }

  void setSocketName(String socketName, int socketNr, String pwsKey) {
    var socket = findSocket(pwsKey, socketNr);
    socket.updateSocketName(socketName);
    notifyListeners();
  }

  void setPowerstripName(String powerstripName, String pwsKey) {
    var powerstrip = findPowerstrip(pwsKey);
    powerstrip.setPowerstripName(powerstripName);
    notifyListeners();
  }

  void setOneSocketStatus(int socketNr, String pwsKey, bool isSocketOn) {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    logger.i("update one socket status");
    var powerstrip = findPowerstrip(pwsKey);
    powerstrip.updateOneSocketStatus(socketNr, isSocketOn);
  }

  PowerstripModel findPowerstrip(String pwsKey) {
    var powerstrip = _powerstrips.firstWhere((element) => element.pwsKey == pwsKey);
    return powerstrip;
  }

  SocketModel findSocket(String pwsKey, int socketNr) {
    var powerstrip = _powerstrips.firstWhere((element) => element.pwsKey == pwsKey);
    var socket = powerstrip.sockets.firstWhere((element) => element.socketNr == socketNr);
    return socket;
  }
}
