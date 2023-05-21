import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminalRepository {
  Future<http.Response> getTerminal() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    return http.get(
      Uri.parse('http://localhost:3000/getpowerstrip/$userId'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }

  Future<http.Response> updateSocket(Socket socket) async {
    return http.post(
      Uri.parse('http://localhost:3000/updateSocketStatus/'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        'id_socket': socket.id_socket.toString(),
        'id_terminal': socket.id_terminal.toString(),
        'status' : socket.status
      }),
    );
  }
}
