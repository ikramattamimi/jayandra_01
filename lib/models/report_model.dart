import 'package:logger/logger.dart';

class ReportModel {
  final String pwsKey;
  final int socketNr;
  final double usage;

  ReportModel({
    this.pwsKey = "Pws-01",
    this.socketNr = 0,
    this.usage = 0,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      pwsKey: json['pws_serial_key'],
      socketNr: json['socket_number'],
      usage: json['usage'],
    );
  }

  void logger() {
    Logger().i({
      "pwsKey" : pwsKey,
      "socketNr" : socketNr,
      "usage" : usage
    });
  }
}
