class FriendModel {
  String id;
  String name;
  String email;

  FriendModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory FriendModel.fromMap({required Map data}) {
    return FriendModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
