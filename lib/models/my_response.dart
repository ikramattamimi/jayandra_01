import 'package:jayandra_01/models/powestrip_model.dart';

class MyResponse<T> {
  int code;
  String message;
  T? data;

  MyResponse({this.code = 0, this.message = "", this.data});

  factory MyResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    return MyResponse(
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? fromJsonModel(json['data']) : null,
    );
  }
}

class MyArrayResponse {
  int code;
  String message;
  List? data;

  MyArrayResponse({this.code = 0, this.message = "", this.data});

  factory MyArrayResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    List objectList = [];

    // List powerstrip dari response API
    final responseObjectList = json['data'];

    // Jika list powerstrip tidak kosong
    if (responseObjectList != null) {
      // Pembuatan objek powerstrip
      for (var responseObject in responseObjectList) {
        objectList.add(fromJsonModel(responseObject));
      }
    }

    return MyArrayResponse(
      // code: (json['code'] != null) ? json['code'] : 0,
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? objectList : null,
    );
  }
}

class PowerstripResponse {
  int code;
  String message;
  List<PowerstripModel>? data;

  PowerstripResponse({this.code = 0, this.message = "", this.data});

  factory PowerstripResponse.fromJsonArray(Map<String, dynamic> json, Function fromJsonModel) {
    List<PowerstripModel> powerstrips = [];

    // List powerstrip dari response API
    final powerstripList = json['data'];

    // Jika list powerstrip tidak kosong
    if (powerstripList != null) {
      // Pembuatan objek powerstrip
      for (var powerstrip in powerstripList) {
        powerstrips.add(fromJsonModel(powerstrip));
      }
    }
    return PowerstripResponse(
      // code: (json['code'] != null) ? json['code'] : 0,
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? powerstrips : null,
    );
  }
}
