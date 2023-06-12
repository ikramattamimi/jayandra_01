import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class ConnectivityStatus {
  static Future<void> checkConnectivityState() async {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      // Operasi asinkron yang dapat menyebabkan <asynchronous suspension>
      await Connectivity().checkConnectivity();
    } catch (e) {
      // Tangani pengecualian
      logger.e('Terjadi kesalahan: $e');
    }

    // setState(() {
    //   _connectivityResult = result;
    // });
  }

  Future<void> _tryConnection() async {
    try {
      await InternetAddress.lookup('www.woolha2.com');

      // setState(() {
      // });
    } on SocketException catch (e) {
      // setState(() {
      // });
    }
  }
}
