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
