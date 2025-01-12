import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/TrainerClients/collaboration_model.dart';
import 'package:user_app/Models/TrainingPlan/training_plan_model.dart';

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

  Future<String> getCollaborationId(String planId) async {
    try {
      final snapshot = await _firestore.collection('trainingPlans').doc(planId).get();
      return snapshot.data()?['collaborationId'];
    } catch (e) {
      print('Error getting collaboration id: $e');
      throw Exception('Failed to get collaboration id');
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
