class ExerciseBaseModel {
  final String? id;
  final String name;
  final String description;
  final String muscleGroup;
  final List<String> equipment;


  ExerciseBaseModel({
    this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipment,
  });

  ExerciseBaseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        muscleGroup = json['muscleGroup'] ?? '',
        equipment = json['equipment'] != null
            ? List<String>.from(json['equipment'])
            : [];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['muscleGroup'] = muscleGroup;
    data['equipment'] = equipment;
    return data;
  }
}