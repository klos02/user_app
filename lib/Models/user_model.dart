class UserModel {
  String? name;
  String email;
  String uid;
  List<String>? givenRatingTo;
  double? weight; // Waga w kilogramach
  double? height; // Wzrost w centymetrach
  int? gymExperience; // Staż na siłowni w miesiącach

  UserModel({
    this.name,
    required this.email,
    required this.uid,
    this.givenRatingTo = const [],
    this.weight,
    this.height,
    this.gymExperience,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        uid = json['uid'] ?? '',
        givenRatingTo = List<String>.from(json['givenRatingTo'] ?? []),
        weight = (json['weight'] != null) ? json['weight'].toDouble() : null,
        height = (json['height'] != null) ? json['height'].toDouble() : null,
        gymExperience = json['gymExperience'] != null
            ? int.tryParse(json['gymExperience'].toString())
            : null {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;
    data['givenRatingTo'] = givenRatingTo;
    data['weight'] = weight;
    data['height'] = height;
    data['gymExperience'] = gymExperience;
    return data;
  }
}
