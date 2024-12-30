class UserModel {
  String? name;
  String email;
  String role;
  String uid;

  UserModel(
      {this.name, required this.email, required this.role, required this.uid});

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        role = json['role'] ?? 'user',
        uid = json['uid'] ?? '' {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['uid'] = uid;
    return data;
  }
}
