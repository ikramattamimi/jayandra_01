import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminalRepository {
  Future<http.Response> getTerminal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('id_uesr');
    return http.get(
      Uri.parse('http://localhost:3000/getpowerstrip/$id'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
