import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class ConnectivityStatus {
  static Future<void> checkConnectivityState() async {
    ConnectivityResult? _connectivityResult;
    late StreamSubscription _connectivitySubscription;
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      // Operasi asinkron yang dapat menyebabkan <asynchronous suspension>
      final ConnectivityResult result = await Connectivity().checkConnectivity();
    } catch (e) {
      // Tangani pengecualian
      logger.e('Terjadi kesalahan: $e');
    }

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      logger.i('Current connectivity status: $result');
      _connectivityResult = result;
    });

    // setState(() {
    //   _connectivityResult = result;
    // });
  }

    bool? _isConnectionSuccessful;
 
  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.woolha2.com');
 
      // setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      // });
    } on SocketException catch (e) {
      // setState(() {
        _isConnectionSuccessful = false;
      // });
    }
  }
}
