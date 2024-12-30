class UserModel {
  String? name;
  String email;
  String role;
  String uid;

  UserModel(
      {this.name, required this.email, required this.role, required this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'] ?? '';
    role = json['role'] ?? 'user';
    uid = json['uid'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['uid'] = uid;
    return data;
  }
}
