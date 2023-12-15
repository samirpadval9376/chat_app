class UserModal {
  int id, age;
  String name;

  UserModal({
    required this.id,
    required this.age,
    required this.name,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      id: data['id'],
      age: data['age'],
      name: data['name'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'age': age,
      'name': name,
    };
  }
}
