class User {
  String? name;
  String email;
  String password;

  User({
    required this.email,
    required this.password,
    this.name,
  });
}
