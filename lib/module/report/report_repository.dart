import 'package:http/http.dart' as http;
import 'package:jayandra_01/utils/network_api.dart';

class ReportRepository {
  Future<http.Response> getReportAll(String email) async {
    // Logger().i("budget: ${budget.length}");
    return http.get(
      Uri.parse('${NetworkAPI.ip}/reportAll/$email'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> getReportHome(String email, int homeId) async {
    // Logger().i("budget: ${budget.length}");
    return http.get(
      Uri.parse('${NetworkAPI.ip}/reportPerHome/$email/$homeId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> getReportPowerstrip(String pwsKey) async {
    // Logger().i("budget: ${budget.length}");
    return http.get(
      Uri.parse('${NetworkAPI.ip}/reportPerPowerstrip/$pwsKey'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> getReportDashboard(String email) async {
    // Logger().i("budget: ${budget.length}");
    return http.get(
      Uri.parse('${NetworkAPI.ip}/dashboard/$email'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
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
