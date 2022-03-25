enum UserRole { patient, admin }

class User {
  String email;
  String? password;
  String name;

  UserRole? role;

  User({required this.email, this.password, required this.name, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole _role;

    if (json['role'] == 0) {
      _role = UserRole.patient;
    } else {
      _role = UserRole.admin;
    }

    return User(
        email: json['email'],
        password: json['password'],
        name: json['name'],
        role: _role);
  }
}
