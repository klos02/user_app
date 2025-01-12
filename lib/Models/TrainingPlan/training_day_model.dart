import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/TrainingPlan/exercise_model.dart';

class TrainingDayModel {
  String name;
  int dayNumber;
  List<ExerciseModel> exercises;
  DateTime date;

  TrainingDayModel({
    required this.name,
    required this.dayNumber,
    required this.exercises,
    required this.date,
  });

  TrainingDayModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        dayNumber = json['dayNumber'] ?? 0,
        date = (json['date'] as Timestamp).toDate(),
        exercises = json['exercises'] != null
            ? List<ExerciseModel>.from(
                json['exercises'].map((x) => ExerciseModel.fromJson(x)))
            : [];



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dayNumber'] = dayNumber;
    data['exercises'] = exercises.map((x) => x.toJson()).toList();
    data['date'] = Timestamp.fromDate(date);
    return data;
  }

}