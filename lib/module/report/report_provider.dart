import 'package:flutter/material.dart';
import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/module/report/report_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ReportProvider with ChangeNotifier {
  // final int _userId;
  List<ReportModel> _reportDashboard = [];
  List<ReportModel> _reportAll = [];
  final List<ReportModel> _reportHome = [];
  final List<ReportModel> _reportPowerstrip = [];

  List<ReportModel> get reportDashboard => _reportDashboard;
  List<ReportModel> get reportAll => _reportAll;
  List<ReportModel> get reportHome => _reportHome;
  List<ReportModel> get reportPowerstrip => _reportPowerstrip;

  final _reportController = ReportController();

  ReportProvider() {
    // initializeData();
  }

  final _logger = Logger(
    printer: PrettyPrinter(),
  );

  void addReport(ReportModel report) {
    _reportAll.add(report);
    notifyListeners();
  }

  void removeReport(int index) {
    _reportAll.removeAt(index);
    notifyListeners();
  }

  createReportAllModelsFromApi(String email) async {
    try {
      await _reportController.getRerportAll(email).then((repAll) {
        _reportAll = [];
        for (var report in repAll.data!) {
          _reportAll.add(report);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      _logger.e('Terjadi kesalahan koneksi: $e');
    }
  }

  createReportDashboardModelsFromApi(String email) async {
    try {
      await _reportController.getRerportDashboard(email).then((repDashb) {
        _reportDashboard = [];
        for (var report in repDashb.data!) {
          _reportDashboard.add(report);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      _logger.e('Terjadi kesalahan koneksi: $e');
    }
  }

  createReportHomeModelsFromApi(String email, int homeId) async {
    try {
      await _reportController.getRerportHome(email, homeId).then((repHome) {
        for (var report in repHome.data!) {
          _reportHome.add(report);
        }
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      _logger.e('Terjadi kesalahan koneksi: $e');
    }
  }

  createReportPowerstripModelsFromApi(String pwsKey) async {

    try {
      await _reportController.getRerportPowerstrip(pwsKey).then((repPws) {
        for (var report in repPws.data!) {
          _reportPowerstrip.add(report);
        }
    Logger().i({"pws report": _reportPowerstrip.length});
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      _logger.e('Terjadi kesalahan koneksi: $e');
    }
  }

  void updateReports(List<ReportModel> reports) {
    _reportAll = reports;
  }

  void clearPwsReport() {
    _reportPowerstrip.clear();
    notifyListeners();
  }

  static ReportProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<ReportProvider>(context, listen: listen);
  }
}
