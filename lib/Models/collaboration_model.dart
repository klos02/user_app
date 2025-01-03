import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/request_model.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Models/request_model.dart';

class CollaborationModel extends RequestModel {
  final DateTime startDate;
  DateTime? lastUpdate;
  String? collaborationId;
  List<TrainingPlanModel>? trainingPlans;

  CollaborationModel({
    required super.fromId,
    required super.toId,
    required super.goal,
    required super.sessionsPerWeek,
    required super.updateFrequency,
    required super.additionalNotes,
    required super.fromName,
    required this.startDate,
    this.lastUpdate,
    this.collaborationId,
    this.trainingPlans,
  });

  factory CollaborationModel.fromRequestModel(RequestModel request,
      DateTime startDate, DateTime? lastUpdate, String? collaborationId) {
    return CollaborationModel(
      fromId: request.fromId,
      toId: request.toId,
      goal: request.goal,
      sessionsPerWeek: request.sessionsPerWeek,
      updateFrequency: request.updateFrequency,
      additionalNotes: request.additionalNotes,
      fromName: request.fromName,
      startDate: startDate,
      lastUpdate: lastUpdate,
      collaborationId: collaborationId,
      trainingPlans: [],
    );
  }

  CollaborationModel.fromJson(Map<String, dynamic> json)
      : startDate = json['startDate'] is Timestamp
            ? (json['startDate'] as Timestamp).toDate()
            : DateTime.parse(json['startDate']),
        lastUpdate = json['lastUpdate'] != null
            ? (json['lastUpdate'] is Timestamp
                ? (json['lastUpdate'] as Timestamp).toDate()
                : DateTime.parse(json['lastUpdate']))
            : null,
        collaborationId = json['collaborationId'],
        trainingPlans = json['trainingPlans'] != null
            ? List<TrainingPlanModel>.from(
                json['trainingPlans'].map((x) => TrainingPlanModel.fromJson(x)))
            : [],
        super(
          fromId: json['fromId'],
          toId: json['toId'],
          goal: json['goal'],
          sessionsPerWeek: json['sessionsPerWeek'],
          updateFrequency: json['updateFrequency'],
          additionalNotes: json['additionalNotes'],
          fromName: json['fromName'],
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'fromId': fromId,
      'toId': toId,
      'goal': goal,
      'sessionsPerWeek': sessionsPerWeek,
      'updateFrequency': updateFrequency,
      'additionalNotes': additionalNotes,
      'fromName': fromName,
      'startDate': Timestamp.fromDate(startDate),
      'lastUpdate': lastUpdate != null ? Timestamp.fromDate(lastUpdate!) : null,
      'collaborationId': collaborationId,
      'trainingPlans': trainingPlans?.map((plan) => plan.toJson()).toList(),
    };
  }
}
