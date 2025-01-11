import 'package:user_app/Models/exercise_base_model.dart';
import 'package:user_app/Models/result_model.dart';

class ExerciseModel {
   int sets;
   int reps;
   int rest;
   String? dateName;

  List<ResultModel> results;
  final ExerciseBaseModel baseModel;

  ExerciseModel({
    required this.sets,
    required this.reps,
    required this.rest,
    this.results = const [],
    required this.baseModel,
    this.dateName,
  });

  ExerciseModel.fromJson(Map<String, dynamic> json)
      : sets = json['sets'] ?? 0,
        baseModel = ExerciseBaseModel.fromJson(json['baseModel']),
        reps = json['reps'] ?? 0,
        dateName = json['dateName'] ?? '',
        rest = json['rest'] ?? 0,
        results = json['results'] != null
            ? List<ResultModel>.from(
                json['results'].map((x) => ResultModel.fromJson(x)))
            : [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseModel'] = baseModel.toJson();
    data['sets'] = sets;
    data['reps'] = reps;
    data['rest'] = rest;
    data['results'] = results.map((x) => x.toJson()).toList();
    data['dateName'] = dateName;
    return data;
  }
}
