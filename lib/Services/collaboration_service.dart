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
      await _firestore
          .collection('collaborations')
          .doc(collaborationId)
          .update({
        'trainingPlans': FieldValue.arrayUnion([trainingPlan.toJson()]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> addTrainingPlanToCollaborationFromFirebase(
      String trainingPlanId) async {
    try {
      final trainingPlanRef =
          _firestore.collection('trainingPlans').doc(trainingPlanId);

      final trainingPlanSnapshot = await trainingPlanRef.get();
      if (!trainingPlanSnapshot.exists) {
        throw Exception("Training plan does not exist.");
      }

      final collaborationId = trainingPlanSnapshot.data()?['collabId'];
      final collaborationRef =
          _firestore.collection('collaborations').doc(collaborationId);

      final collaborationSnapshot = await collaborationRef.get();
      if (!collaborationSnapshot.exists) {
        throw Exception("Collaboration does not exist.");
      }

      final trainingPlanData = trainingPlanSnapshot.data();
      final existingPlans = List<Map<String, dynamic>>.from(
          collaborationSnapshot.get('trainingPlans') ?? []);

      final existingPlanIndex = existingPlans
          .indexWhere((plan) => plan['id'] == trainingPlanData?['id']);

      if (existingPlanIndex != -1) {
        existingPlans[existingPlanIndex].addAll(trainingPlanData!);
      } else {
        existingPlans.add(trainingPlanData!);
      }

      await collaborationRef.update({'trainingPlans': existingPlans});
    } on FirebaseException catch (e) {
      print("FirebaseException: $e");
    } catch (e) {
      print("Exception: $e");
    }
  }
}
