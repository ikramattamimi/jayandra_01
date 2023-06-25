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

  Future<MyArrayResponse> getRerportPowerstrip(String homeName, String pwsKey, String email) async {

    try {
      http.Response result = await reportRepo.getReportPws(homeName, pwsKey, email);

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

  Future<MyArrayResponse> getRerportSocket(String homeName, String pwsKey, String email) async {

    try {
      http.Response result = await reportRepo.getReportSocket(homeName, pwsKey, email);

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
