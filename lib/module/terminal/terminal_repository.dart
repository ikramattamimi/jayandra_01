import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/utils/network_api.dart';
import 'package:logger/logger.dart';

class TerminalRepository {
  Future<http.Response> getTerminal(int userId) async {
    return http.get(
      Uri.parse('${NetworkAPI.ip}/getpowerstrip/$userId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> setSocketStatus(int socketId, int terminalId, bool status) async {
    Logger(printer: PrettyPrinter()).i("API set socket status");
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateSocketStatus/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': socketId,
          'id_terminal': terminalId,
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
          'id_terminal': socket.terminalId,
          'name': socket.name,
        },
      ),
    );
  }

  Future<http.Response> updateTerminalName(TerminalModel terminal) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateTerminalName/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_terminal': terminal.id,
          'name': terminal.name,
        },
      ),
    );
  }

  Future<http.Response> changeAllSocketStatus(int idTerminal, bool status) async {
    int updateStatus = status == true ? 1 : 0;
    return http.post(
      Uri.parse('${NetworkAPI.ip}/changeAllSocketStatus/$idTerminal/$updateStatus'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
