import 'package:user_app/Models/TrainerClients/collaboration_model.dart';

class UserModel {
  String? name;
  String email;
  String uid;
  List<String>? givenRatingTo;
  double? weight; // Waga w kilogramach
  double? height; // Wzrost w centymetrach
  int? gymExperience; // Staż na siłowni w miesiącach
  List<CollaborationModel>? collaborations;

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
    collaborations = json['collaborations'] != null
        ? List<CollaborationModel>.from(
            json['collaborations'].map((x) => CollaborationModel.fromJson(x)))
        : [];
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
    data['collaborations'] = collaborations?.map((x) => x.toJson()).toList();
    return data;
  }
}
