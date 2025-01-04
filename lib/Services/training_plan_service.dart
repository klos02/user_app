import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/collaboration_model.dart';
import 'package:user_app/Models/training_plan_model.dart';

class TrainingPlanService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> createTrainingPlan(TrainingPlanModel trainingPlan) async {
    try {
      final docRef = _firestore.collection('trainingPlans').doc();

      trainingPlan.id = docRef.id;

      await docRef.set(trainingPlan.toJson());

      return trainingPlan.id!;
    } catch (e) {
      print('Error creating training plan: $e');
      throw Exception('Failed to create training plan');
    }
  }

  int calculateTimeTillUpdate(CollaborationModel collab, DateTime startDate) {
    final lastUpdateDate = collab.lastUpdate ?? startDate;
    String updateFrequency = collab.updateFrequency;
    int daysToAdd = 0;
    switch (updateFrequency) {
      case 'Weekly':
        daysToAdd = 7;
        break;
      case 'Bi-weekly':
        daysToAdd = 14;
        break;
      case 'Monthly':
        daysToAdd = 30;
        break;
      default:
        daysToAdd = 7;
    }
    
    return daysToAdd - DateTime.now().difference(lastUpdateDate).inDays;
  }
}
