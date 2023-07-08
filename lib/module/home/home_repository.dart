import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class HomeRepository {
  Future<http.Response> addHome(String homeName, String className, String email, String budget) async {
    // Logger().i("budget: ${budget.length}");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/createHome'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{'class_name': className, 'home_name': homeName, 'budget': budget.isNotEmpty ? double.parse(budget) : 0.0, 'email': email}),
    );
  }

  Future<http.Response> getHome(String email) async {
    return http.get(
      Uri.parse('${NetworkAPI.ip}/getHome/$email'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> updateHome(HomeModel home) async {
    // Logger().i("budget: ${budget.length}");
    return http.put(
      Uri.parse('${NetworkAPI.ip}/updateHome/${home.homeId}'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{
        'class_name': home.className,
        'home_name': home.homeName,
        'budget': home.budget,
      }),
    );
  }
}
