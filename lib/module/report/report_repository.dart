import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/utils/network_api.dart';

class ReportRepository {
  Future<http.Response> getReportAll(String email) async {
    // Logger().i("budget: ${budget.length}");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/reportAll'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{
        'email' : email
      }),
    );
  }
  Future<http.Response> getReportPws(String homeName, String pwsKey, String email) async {
    // Logger().i("budget: ${budget.length}");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/reportPerHome'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{
        'home_name' : homeName,
        'pws_serial_key' : pwsKey,
        'email' : email
      }),
    );
  }
  Future<http.Response> getReportSocket(String homeName, String pwsKey, String email) async {
    // Logger().i("budget: ${budget.length}");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/reportPerPowerstrip'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{
        'home_name' : homeName,
        'pws_serial_key' : pwsKey,
        'email' : email
      }),
    );
  }

  // Future<http.Response> getReportAll(String email) async {
  //   return http.get(
  //     Uri.parse('${NetworkAPI.ip}/getReport/$email'),
  //     headers: <String, String>{
  //       'Content-Type': "application/json; charset=UTF-8",
  //     },
  //   );
  // }
}
