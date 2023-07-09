import 'dart:convert';

import 'package:jayandra_01/models/report_model.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/module/report/report_repository.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ReportController {
  final ReportRepository reportRepo = ReportRepository();

  Future<MyArrayResponse> getRerportAll(String email) async {
    try {
      http.Response result = await reportRepo.getReportAll(email);

      Map<String, dynamic> myBody = jsonDecode(result.body);
      // Logger().i(myBody);

      var myResponse = MyArrayResponse.fromJson(myBody, ReportModel.fromJson);
      if (result.statusCode == 200) {
        myResponse.message = "Report Berhasil Ditambahkan";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyArrayResponse();
    }
  }

  Future<MyArrayResponse> getRerportHome(String email, int homeId) async {
    try {
      http.Response result = await reportRepo.getReportHome(email, homeId);

      Map<String, dynamic> myBody = jsonDecode(result.body);

      var myResponse = MyArrayResponse.fromJson(myBody, ReportModel.fromJson);
      if (result.statusCode == 200) {
        myResponse.message = "Report Berhasil Ditambahkan";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyArrayResponse();
    }
  }

  Future<MyArrayResponse> getRerportPowerstrip(String pwsKey) async {
    try {
      http.Response result = await reportRepo.getReportPowerstrip(pwsKey);

      Map<String, dynamic> myBody = jsonDecode(result.body);

      var myResponse = MyArrayResponse.fromJson(myBody, ReportModel.fromJson);
      if (result.statusCode == 200) {
        myResponse.message = "Report Berhasil Ditambahkan";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyArrayResponse();
    }
  }

  Future<MyArrayResponse> getRerportDashboard(String email) async {
    try {
      http.Response result = await reportRepo.getReportDashboard(email);

      Map<String, dynamic> myBody = jsonDecode(result.body);

      var myResponse = MyArrayResponse.fromJson(myBody, ReportModel.fromJson);
      if (result.statusCode == 200) {
        myResponse.message = "Report Berhasil Ditambahkan";
      }
      return myResponse;
    } catch (e) {
      Logger().e(e);
      return MyArrayResponse();
    }
  }
}
