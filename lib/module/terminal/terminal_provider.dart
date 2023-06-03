import 'package:flutter/material.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:provider/provider.dart';

class TerminalProvider with ChangeNotifier {
  // final int _userId;
  List<TerminalModel> _terminals = [];

  List<TerminalModel> get terminals => _terminals;

  final _terminalController = TerminalController();

  TerminalProvider() {
    // initializeData();
  }

  void addTerminal(TerminalModel terminal) {
    _terminals.add(terminal);
    notifyListeners();
  }

  void removeTerminal(int index) {
    _terminals.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeData(int userId) async {
    List<TerminalModel> terminalModels = await createTerminalModelsFromApi(userId);
    _terminals = terminalModels;
    notifyListeners();
    // }
  }

  Future<List<TerminalModel>> createTerminalModelsFromApi(userId) async {
    List<TerminalModel> terminalModels = [];
    await _terminalController.getTerminal(userId).then((value) {
      terminalModels = value!.data!;
    });
    return terminalModels;
  }

  void updateTerminals(List<TerminalModel> terminals) {
    _terminals = terminals;
  }

  static TerminalProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TerminalProvider>(context, listen: listen);
  }
}
