import 'package:user_app/Models/collaboration_model.dart';

class TrainerModel {
  String? name;
  String email;
  String uid;
  double? rating;
  int? nrOfRatings;
  List<String>? collaborations;

  TrainerModel(
      {this.name, required this.email, required this.uid, this.rating, this.nrOfRatings});

  TrainerModel.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        uid = json['uid'] ?? '' {
    name = json['name'];
    rating = json['rating'];
    nrOfRatings = json['nrOfRatings'];
    collaborations = json['collaborations'] != null
        ? List<String>.from(json['collaborations'].map((x) => x))
        : [];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;
    data['rating'] = rating;
    data['nrOfRatings'] = nrOfRatings;
    data['collaborations'] = collaborations;
    return data;
  }
}
