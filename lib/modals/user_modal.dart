class UserModal {
  String email = "";
  String password = "";

  UserModal({
    required this.email,
    required this.password,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      email: data['email'],
      password: data['password'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'email': email,
      'password': password,
    };
  }
}
