class MyResponse<T> {
  String code;
  String? message;
  T? data;

  MyResponse({this.code = "", this.message = "", this.data});

  factory MyResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    return MyResponse(
      code: json['token'],
      message: json['message'],
      data: (json['data'] != null) ? fromJsonModel(json['data']) : null,
    );
  }
}
