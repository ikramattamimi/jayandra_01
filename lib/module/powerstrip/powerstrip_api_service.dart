import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/utils/network_api.dart';
import 'package:logger/logger.dart';

class PowerstripAPIService {
  Future<http.Response> getPowerstrip(int userId) async {
    return http.get(
      Uri.parse('${NetworkAPI.ip}/getpowerstrip/$userId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> setSocketStatus(int socketId, int powerstripId, bool status) async {
    Logger(printer: PrettyPrinter()).i("API set socket status");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateSocketStatus/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': socketId,
          'id_terminal': powerstripId,
          'status': status,
        },
      ),
    );
  }

  Future<http.Response> updateSocketName(SocketModel socket) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateSocketName/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': socket.socketId,
          'id_terminal': socket.powerstripId,
          'name': socket.name,
        },
      ),
    );
  }

  Future<http.Response> updatePowerstripName(PowerstripModel powerstrip) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateTerminalName/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_terminal': powerstrip.id.toString(),
          'name': powerstrip.name,
        },
      ),
    );
  }

  Future<http.Response> changeAllSocketStatus(int idPowerstrip, bool status) async {
    int updateStatus = status == true ? 1 : 0;
    return http.post(
      Uri.parse('${NetworkAPI.ip}/changeAllSocketStatus/$idPowerstrip/$updateStatus'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
