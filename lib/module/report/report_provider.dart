import 'package:flutter/material.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/report/report_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ReportProvider with ChangeNotifier {
  // final int _userId;
  List<ReportModel> _reportAll = [];
  List<ReportModel> _reportPowerstrip = [];
  List<ReportModel> _reportSocket = [];

  List<ReportModel> get reportAll => _reportAll;
  List<ReportModel> get reportPowerstrip => _reportPowerstrip;
  List<ReportModel> get reportSocket => _reportSocket;

  final _reportController = ReportController();

  ReportProvider() {
    // initializeData();
  }

  void addReport(ReportModel report) {
    _reportAll.add(report);
    notifyListeners();
  }

  void removeReport(int index) {
    _reportAll.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeData(String homeName, String pwsKey, String email) async {
    await createReportModelsFromApi(homeName, pwsKey, email); // nanti ganti sama email
    // for (var report in _reportAll) {
    //   report.logger();
    // }
    // for (var report in _reportPowerstrip) {
    //   report.logger();
    // }
    // for (var report in _reportSocket) {
    //   report.logger();
    // }
    notifyListeners();
  }

  createReportModelsFromApi(String homeName, String pwsKey, String email) async {
    List<ReportModel> reportAll = [];
    List<ReportModel> reportPowerstrip = [];
    List<ReportModel> reportSocket = [];
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      await _reportController.getRerportAll(email).then((repAll) {
        for (var report in repAll.data!) {
          reportAll.add(report);
        }
      });
      await _reportController.getRerportPowerstrip(homeName, pwsKey, email).then((repPws) {
        for (var report in repPws.data!) {
          reportPowerstrip.add(report);
        }
      });
      await _reportController.getRerportSocket(homeName, pwsKey, email).then((repSocket) {
        for (var report in repSocket.data!) {
          reportSocket.add(report);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      logger.e('Terjadi kesalahan koneksi: $e');
    }
    _reportAll = reportAll;
    _reportPowerstrip = reportPowerstrip;
    _reportSocket = reportSocket;
  }

  void updateReports(List<ReportModel> reports) {
    _reportAll = reports;
  }

  static ReportProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<ReportProvider>(context, listen: listen);
  }

  // void updateSocketName(String socketName, int socketId, int reportId) async {
  //   var report = _reports.firstWhere((element) => element.id == reportId);
  //   var socket = report.sockets!.firstWhere((element) => element.socketId == socketId);
  //   socket.updateSocketName(socketName);
  //   await _reportController.updateSocketName(socket);
  //   notifyListeners();
  // }

  // void updateReportName(String reportName, int reportId) async {
  //   var report = _reports.firstWhere((element) => element.id == reportId);
  //   report.setReportName(reportName);
  //   notifyListeners();
  //   await _reportController.updateReportName(report);
  // }

  // void updateOneSocketStatus(int socketId, int reportId, bool isSocketOn) {
  //   var logger = Logger(
  //     printer: PrettyPrinter(),
  //   );
  //   logger.i("update one socket status");
  //   var report = findReport(reportId);
  //   report.updateOneSocketStatus(socketId, isSocketOn);
  // }

  // ReportModel findReport(String email, String reportName) {
  //   var report = _reports.firstWhere((element) => element.email == email && element.reportName == reportName);
  //   return report;
  // }
}
