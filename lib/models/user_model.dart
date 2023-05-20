class User {
  final int? id;
  final String? name;
  final String email;
  final String? password;
  final String? electricityclass;
  final String? token;

  User({this.id = 0, this.name = "", this.email = "", this.password = "", this.electricityclass = "", this.token = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: (json['password'] != null) ? json['password'] : "",
      electricityclass: (json['electricityclass'] != "") ? json['electricityClass'] : "",
      token: json['token'],
    );
  }
}
