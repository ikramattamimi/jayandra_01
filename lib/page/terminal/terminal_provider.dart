import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jayandra_01/models/my_response.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_repository.dart';
import 'package:provider/provider.dart';

class TerminalProvider with ChangeNotifier {
  List<TerminalModel> _terminal = [];

  List<TerminalModel> get terminal => _terminal;

  final _terminalRepository = TerminalRepository();

    TerminalProvider() {
    initializeData();
  }

  void addTerminal(TerminalModel terminal) {
    _terminal.add(terminal);
    notifyListeners();
  }

  void removeTerminal(int index) {
    _terminal.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeData() async {
    final terminalModels = await createTerminalModelsFromApi();
    _terminal = terminalModels;
    notifyListeners();
  }

  Future<List<TerminalModel>> createTerminalModelsFromApi() async {
    var terminalObjectResponse = TerminalResponse();

    // Logika pemanggilan API untuk mendapatkan data terminal
    // Get API data terminal
    await _terminalRepository.getTerminal().then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        // Parse String json ke Map
        Map<String, dynamic> terminalMapData = jsonDecode(value.body);

        // Response dengan response.data berupa List dari objek Terminal
        terminalObjectResponse = TerminalResponse.fromJsonArray(terminalMapData, TerminalModel.fromJson);
        terminalObjectResponse.message = "Data terminal berhasil dimuat";
      } 
    });

    // Contoh data hardcoded:
    // final terminalJsonData = [
    //   {'id': 1, 'time': 60},
    //   {'id': 2, 'time': 120},
    // ];

    List<TerminalModel> terminalModels = [];
    for (var terminalData in terminalObjectResponse.data!) {
      terminalModels.add(terminalData);
    }
    return terminalModels;
  }

  static TerminalProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TerminalProvider>(context, listen: listen);
  }

  void changeTerminalStatus(int terminalId, bool isTerminalOn) {
    final terminal = _terminal.firstWhere((terminal) => terminal.id == terminalId);
    terminal.updateTerminalStatus(isTerminalOn);
    notifyListeners();
  }
}
