class AuthEntity {
  final String email;
  final String password;
  final String? name;

  AuthEntity({
    required this.email,
    required this.password,
    this.name,
  });
}
