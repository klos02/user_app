import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addRequest(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('trainerRequests').doc().set(data);
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }
}