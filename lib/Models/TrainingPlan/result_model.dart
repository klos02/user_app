import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  int weight;
  int reps;
  int setNumber;
  DateTime timestamp;
  String? dateName;

  ResultModel({
    required this.weight,
    required this.reps,
    required this.setNumber,
    required this.timestamp,
    this.dateName,
  });

  ResultModel.fromJson(Map<String, dynamic> json)
      : weight = json['weight'] ?? 0.0,
        reps = json['reps'] ?? 0,
        dateName = json['dateName'] ?? '',
        setNumber = json['setNumber'] ?? 0,
        timestamp = (json['timestamp'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
      'setNumber': setNumber,
      'timestamp': Timestamp.fromDate(timestamp),
      'dateName': dateName,
    };
  }
}
