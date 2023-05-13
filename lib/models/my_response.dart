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

class MyArrayResponse<T> {
  int code;
  String message;
  List<T>? data;

  MyArrayResponse({this.code = 0, this.message = "", this.data});

  factory MyArrayResponse.fromJsonArray(Map<String, dynamic> json, Function fromJsonModel) {
    List<T> myList = [];
    final arrayData = json['data'];
    if (arrayData != null) {
      for (var element in arrayData) {
        myList.add(fromJsonModel(element));
      }
    }
    return MyArrayResponse(
      // code: (json['code'] != null) ? json['code'] : 0,
      code: json['code'],
      message: json['message'],
      data: (json['data'] != null) ? myList : null,
    );
  }
}
