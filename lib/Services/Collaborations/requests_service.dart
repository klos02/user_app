import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/TrainerClients/request_model.dart';

class RequestsService {
  final _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> createRequest(RequestModel request) {
    final data = {
      'fromId': request.fromId,
      'toId': request.toId,
      'goal': request.goal,
      'sessionsPerWeek': request.sessionsPerWeek,
      'updateFrequency': request.updateFrequency,
      'additionalNotes': request.additionalNotes,
      'fromName': request.fromName,
      'status': 'pending',
    };

    return data;
  }

  Future<void> sendRequest(Map<String, dynamic> data) async {
    try {
      final docRef = _firestore.collection('trainerRequests').doc();
      final requestId = docRef.id;
      data['requestId'] = requestId;

      await docRef.set(data);
    } on FirebaseException catch (e) {
      print(e); 
    }
  }

  Future<bool> hasUserSentRequest(String fromId, String toId) async {
    try {
      final snapshot = await _firestore
          .collection('trainerRequests')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .get();

      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      print(e); 
      return false;
    }
  }

  Future<bool> userHasActiveCollaboration(String fromId, String toId) async {
    try {
      final snapshot = await _firestore
          .collection('collaborations')
          .where('fromId', isEqualTo: fromId)
          .where('toId', isEqualTo: toId)
          .get();

      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      print(e); 
      return false;
    }
  }
}
