class ExerciseBaseModel {
  final String? id;
  final String name;
  final String description;
  final String muscleGroup;


  ExerciseBaseModel({
    this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
  });

  ExerciseBaseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        muscleGroup = json['muscleGroup'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['muscleGroup'] = muscleGroup;
    return data;
  }
}