import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/collaboration_model.dart';
import 'package:user_app/Models/training_plan_model.dart';

class CollaborationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CollaborationModel>> getCollaborationsForId(String userId) {
    return _firestore
        .collection('collaborations')
        .where('fromId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CollaborationModel.fromJson(data);
      }).toList();
    });
  }


  Future<void> addCollabToUsers(
      String trainerId, String userId, String collabId) async {
    try {
      await _firestore.collection('trainers').doc(trainerId).update({
        'collaborations': FieldValue.arrayUnion([collabId])
      });

      await _firestore.collection('users').doc(userId).update({
        'collaborations': FieldValue.arrayUnion([collabId])
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // Future<void> addTrainingPlanToCollaboration(
  //     String collaborationId, String trainingPlanId) async {
  //   try {
  //     await _firestore.collection('collaborations').doc(collaborationId).update({
  //       'trainingPlans': FieldValue.arrayUnion([trainingPlanId])
  //     });
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> addTrainingPlanToCollaboration(
      String collaborationId, TrainingPlanModel trainingPlan) async {
    try {
      // Dodajemy cały obiekt planu treningowego do listy 'trainingPlans'
      await _firestore.collection('collaborations').doc(collaborationId).update({
        'trainingPlans': FieldValue.arrayUnion([trainingPlan.toJson()]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
