import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/timer_model.dart';
import 'package:jayandra_01/utils/network_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminalRepository {
  Future<http.Response> getTerminal() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    return http.get(
      Uri.parse('${NetworkAPI.ip}/getpowerstrip/$userId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> updateSocket(Socket socket) async {
    return http.post(
      Uri.parse('${NetworkAPI.ip}/updateSocketStatus/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {
          'id_socket': socket.id_socket.toString(),
          'id_terminal': socket.id_terminal.toString(),
          'status': socket.status,
        },
      ),
    );
  }

  Future<http.Response> changeAllSocketStatus(int id_terminal, bool status) async {
    int updateStatus = status == true ? 1 : 0;
    return http.post(
      Uri.parse('${NetworkAPI.ip}/changeAllSocketStatus/$id_terminal/$updateStatus'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

}
