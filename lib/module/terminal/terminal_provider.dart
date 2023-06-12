import 'package:flutter/material.dart';
import 'package:jayandra_01/models/terminal_model.dart';
import 'package:jayandra_01/module/terminal/terminal_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class TerminalProvider with ChangeNotifier {
  // final int _userId;
  List<TerminalModel> _terminals = [];

  List<TerminalModel> get terminals => _terminals;

  static final TerminalProvider instance = TerminalProvider._();
  TerminalProvider._();

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
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    try {
      await _terminalController.getTerminal(userId).then((value) {
        terminalModels = value!.data!;
      });
    } catch (e) {
      // Tangani pengecualian "Connection refused"
      logger.e('Terjadi kesalahan koneksi: $e');
    }
    return terminalModels;
  }

  void updateTerminals(List<TerminalModel> terminals) {
    _terminals = terminals;
  }

  static TerminalProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TerminalProvider>(context, listen: listen);
  }

  void updateSocketName(String socketName, int socketId, int terminalId) async {
    var terminal = _terminals.firstWhere((element) => element.id == terminalId);
    var socket = terminal.sockets!.firstWhere((element) => element.socketId == socketId);
    socket.updateSocketName(socketName);
    await _terminalController.updateSocketName(socket);
    notifyListeners();
  }

  void updateTerminalName(String terminalName, int terminalId) async {
    var terminal = _terminals.firstWhere((element) => element.id == terminalId);
    terminal.setTerminalName(terminalName);
    notifyListeners();
    await _terminalController.updateTerminalName(terminal);
  }

  void updateOneSocketStatus(int socketId, int terminalId, bool isSocketOn) {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    logger.i("update one socket status");
    var terminal = findTerminal(terminalId);
    terminal.updateOneSocketStatus(socketId, isSocketOn);
  }

  TerminalModel findTerminal(int terminalId) {
    var terminal = _terminals.firstWhere((element) => element.id == terminalId);
    return terminal;
  }
}
