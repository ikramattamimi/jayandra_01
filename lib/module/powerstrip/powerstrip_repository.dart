import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/utils/network_api.dart';

class PowerstripRepository {
  Future<http.Response> getPowerstrip(int homeId) async {
    return http.get(Uri.parse('${NetworkAPI.ip}/getpowerstrip/$homeId'), headers: <String, String>{
      'Content-Type': "application/json; charset=UTF-8",
    });
  }

  Future<http.Response> setSocketStatus(int socketNr, String pwsKey, bool socketStatus) async {
    // Logger(printer: PrettyPrinter()).i("API set socket status");
    return http.put(
      Uri.parse('${NetworkAPI.ip}/updateSocketStatus/$pwsKey/$socketNr'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'socket_status': socketStatus,
        },
      ),
    );
  }

  Future<http.Response> updateSocketName(SocketModel socket) async {
    return await http.put(
      Uri.parse('${NetworkAPI.ip}/updateSocketName/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'socket_number': socket.socketNr,
          'pws_serial_key': socket.pwsKey,
          'socket_name': socket.name,
        },
      ),
    );
  }

  Future<http.Response> updatePowerstripName(PowerstripModel pwsModel, String homeName, String email) async {
    return http.put(
      Uri.parse('${NetworkAPI.ip}/updatePowerstripName/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'pws_serial_key': pwsModel.pwsKey,
          'pws_name': pwsModel.pwsName,
          'home_name': homeName,
          'email': email,
        },
      ),
    );
  }

  Future<http.Response> changeAllSocketStatus(String pwsKey, bool status) async {
    int updateStatus = status == true ? 1 : 0;
    return http.put(
      Uri.parse('${NetworkAPI.ip}/changeAllSocketStatus/$pwsKey/$updateStatus'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
