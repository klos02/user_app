
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/training_day_model.dart';

class TrainingPlanModel {
  String? id;
  final startDate;
  List<TrainingDayModel> trainingDays;

  TrainingPlanModel({
    this.id,
    required this.startDate,
    required this.trainingDays,
  });

  TrainingPlanModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
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
    return data;
  }

}