
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/training_day_model.dart';

class TrainingPlanModel {
  String name;
  String? description;
  String? id;
  DateTime startDate;
  List<TrainingDayModel> trainingDays;

  TrainingPlanModel({
    this.id,
    this.description,
    required this.startDate,
    required this.trainingDays,
    required this.name,
  });

  TrainingPlanModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        startDate = json['startDate'] is Timestamp
            ? (json['startDate'] as Timestamp).toDate()
            : DateTime.parse(json['startDate']),
        trainingDays = json['trainingDays'] != null
            ? List<TrainingDayModel>.from(
                json['trainingDays'].map((x) => TrainingDayModel.fromJson(x)))
            : [];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDate'] = startDate;
    data['trainingDays'] = trainingDays.map((x) => x.toJson()).toList();
    data['name'] = name;
    data['description'] = description;
    return data;
  }

}