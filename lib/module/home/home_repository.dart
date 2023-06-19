import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/utils/network_api.dart';
import 'package:provider/provider.dart';

class HomeRepository {
  Future<http.Response> addHome(String homeName, String className, int userId, String budget) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/createHome'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String?, dynamic>{
        'class_name': className,
        'home_name': homeName,
        'budget': budget != "" ? double.parse(budget) : 0.0,
        'id_user': userId, // masih pake id user, nanti ganti jadi email
      }),
    );
  }

  Future<http.Response> getHome(String userId) async {
    return http.get(
      Uri.parse('${NetworkAPI.ip}/getHome/$userId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
