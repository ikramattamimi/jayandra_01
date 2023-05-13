import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jayandra_01/models/terminal_model.dart';

class TerminalRepository {
  Future<http.Response> getTerminal() async {
    return http.get(
      Uri.parse('http://localhost:3000/getpowerstrip'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );
  }
}
