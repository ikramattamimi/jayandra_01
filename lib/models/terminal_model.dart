class Terminal {
  final int id;
  final String name;

  Terminal({this.id = 0, this.name = ""});
  // final int user_id;

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      name: json['name'],
      // user_id: json['user_id'],
    );
  }
}
