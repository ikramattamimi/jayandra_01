class User {
  final String name;
  final String username;
  final String password;

  User({this.name = "", this.username = "", this.password = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['uername'],
      password: json['password'],
    );
  }
}
