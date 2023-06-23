import 'package:flutter/material.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/module/home/home_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class HomeProvider with ChangeNotifier {
  // final int _userId;
  List<HomeModel> _homes = [];

  List<HomeModel> get homes => _homes;

  static final HomeProvider instance = HomeProvider._();
  HomeProvider._();

  final _homeController = HomeController();

  HomeProvider() {
    // initializeData();
  }

  void addHome(HomeModel home) {
    _homes.add(home);
    notifyListeners();
  }

  void removeHome(int index) {
    _homes.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeData(int userId) async {
    List<HomeModel> homeModels = await createHomeModelsFromApi(userId); // nanti ganti sama email
    _homes = homeModels;
    notifyListeners();
  }

  Future<List<HomeModel>> createHomeModelsFromApi(int userId) async {
    List<HomeModel> homeModels = [];
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      await _homeController.getHome(userId).then((value) {
        for (var home in value.data!) {
          homeModels.add(home);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      logger.e('Terjadi kesalahan koneksi: $e');
    }
    return homeModels;
  }

  void updateHomes(List<HomeModel> homes) {
    _homes = homes;
  }

  static HomeProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<HomeProvider>(context, listen: listen);
  }

  // void updateSocketName(String socketName, int socketId, int homeId) async {
  //   var home = _homes.firstWhere((element) => element.id == homeId);
  //   var socket = home.sockets!.firstWhere((element) => element.socketId == socketId);
  //   socket.updateSocketName(socketName);
  //   await _homeController.updateSocketName(socket);
  //   notifyListeners();
  // }

  // void updateHomeName(String homeName, int homeId) async {
  //   var home = _homes.firstWhere((element) => element.id == homeId);
  //   home.setHomeName(homeName);
  //   notifyListeners();
  //   await _homeController.updateHomeName(home);
  // }

  // void updateOneSocketStatus(int socketId, int homeId, bool isSocketOn) {
  //   var logger = Logger(
  //     printer: PrettyPrinter(),
  //   );
  //   logger.i("update one socket status");
  //   var home = findHome(homeId);
  //   home.updateOneSocketStatus(socketId, isSocketOn);
  // }

  HomeModel findHome(int homeId) {
    var home = _homes.firstWhere((element) => element.userId == homeId);
    return home;
  }
}
