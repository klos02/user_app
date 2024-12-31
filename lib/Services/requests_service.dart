import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/request_model.dart';

class RequestsService {
  final _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> createRequest(String fromId, String toId, String goal,
      int sessionsPerWeek, String updateFrequency, String additionalNotes) {
    final data = {
      'fromId': fromId,
      'toId': toId,
      'goal': goal,
      'sessionsPerWeek': sessionsPerWeek,
      'updateFrequency': updateFrequency,
      'additionalNotes': additionalNotes,
      'status': 'pending',
    };

    return data;
  }

  Future<void> sendRequest(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('trainerRequests').doc().set(data);
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }
}
