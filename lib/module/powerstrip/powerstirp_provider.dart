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

  Future<void> initializeData(int userId) async {
    List<PowerstripModel> powerstripModels = await createPowerstripModelsFromApi(userId);
    _powerstrips = powerstripModels;
    notifyListeners();
  }

  Future<List<PowerstripModel>> createPowerstripModelsFromApi(userId) async {
    List<PowerstripModel> powerstripModels = [];
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      await _powerstripController.getPowerstrip(16).then((value) {
        for (var powerstrip in value!.data!) {
          powerstripModels.add(powerstrip);
          // powerstrip.logger();
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

  void setSocketName(String socketName, int socketId, int powerstripId) {
    var socket = findSocket(powerstripId, socketId);
    socket.updateSocketName(socketName);
    notifyListeners();
  }

  void setPowerstripName(String powerstripName, int powerstripId) async {
    var powerstrip = findPowerstrip(powerstripId);
    powerstrip.setPowerstripName(powerstripName);
    notifyListeners();
    await _powerstripController.updatePowerstripName(powerstrip);
  }

  void setOneSocketStatus(int socketId, int powerstripId, bool isSocketOn) {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    logger.i("update one socket status");
    var powerstrip = findPowerstrip(powerstripId);
    powerstrip.updateOneSocketStatus(socketId, isSocketOn);
  }

  PowerstripModel findPowerstrip(int powerstripId) {
    var powerstrip = _powerstrips.firstWhere((element) => element.id == powerstripId);
    return powerstrip;
  }

  SocketModel findSocket(int powerstripId, int socketId) {
    var powerstrip = _powerstrips.firstWhere((element) => element.id == powerstripId);
    var socket = powerstrip.sockets.firstWhere((element) => element.socketId == socketId);
    return socket;
  }
}
