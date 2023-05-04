class User {
  final int id;
  final String name;
  final String email;
  final String electricityclass;
  final String token;

  User({this.id = 0, this.name = "", this.email = "", this.electricityclass = "", this.token = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      electricityclass: (json['electricityclass'] != "") ? json['electricityClass'] : "",
      token: json['token'],
    );
  }
}
