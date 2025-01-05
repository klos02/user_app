import 'package:user_app/Models/result_model.dart';

class ExerciseModel {
  final String name;
  final String description;
  final int sets;
  final int reps;
  final int rest;
  final String muscleGroup;
  List<ResultModel> results;

  ExerciseModel({
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.muscleGroup,
    this.results = const [],
  });

  ExerciseModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        description = json['description'] ?? '',
        sets = json['sets'] ?? 0,
        reps = json['reps'] ?? 0,
        rest = json['rest'] ?? 0,
        muscleGroup = json['muscleGroup'] ?? '',
        results = json['results'] != null
            ? List<ResultModel>.from(
                json['results'].map((x) => ResultModel.fromJson(x)))
            : [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['sets'] = sets;
    data['reps'] = reps;
    data['rest'] = rest;
    data['muscleGroup'] = muscleGroup;
    data['results'] = results.map((x) => x.toJson()).toList();
    return data;
  }
}
