import 'package:user_app/Models/exercise_model.dart';
import 'package:user_app/Models/exercise_model.dart';

class TrainingDayModel {
  String name;
  int dayNumber;
  List<ExerciseModel> exercises;

  TrainingDayModel({
    required this.name,
    required this.dayNumber,
    required this.exercises,
  });

  TrainingDayModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        dayNumber = json['dayNumber'] ?? 0,
        exercises = json['exercises'] != null
            ? List<ExerciseModel>.from(
                json['exercises'].map((x) => ExerciseModel.fromJson(x)))
            : [];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dayNumber'] = dayNumber;
    data['exercises'] = exercises.map((x) => x.toJson()).toList();
    return data;
  }

}