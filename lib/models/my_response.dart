import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';

class MyResponse<T> {
  int code;
  String message;
  T? data;

  MyResponse({this.code = 0, this.message = "", this.data});

  factory MyResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    return MyResponse(
      // code: (json['code'] != null) ? json['code'] : 0,
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? fromJsonModel(json['data']) : null,
    );
  }
}

class TerminalResponse {
  int code;
  String message;
  List<Terminal>? data;

  TerminalResponse({this.code = 0, this.message = "", this.data});

  factory TerminalResponse.fromJsonArray(Map<String, dynamic> json, Function fromJsonModel) {
    List<Terminal> terminals = [];

    // List terminal dari response API
    final terminalList = json['data'];

    // Jika list terminal tidak kosong
    if (terminalList != null) {
      // Pembuatan objek terminal
      for (var terminal in terminalList) {
        terminals.add(fromJsonModel(terminal));
      }
    }
    return TerminalResponse(
      // code: (json['code'] != null) ? json['code'] : 0,
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? terminals : null,
    );
  }
}
