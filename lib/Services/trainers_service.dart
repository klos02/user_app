import 'package:cloud_firestore/cloud_firestore.dart';

class TrainersService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTrainers() {
    return _firestore
        .collection('trainers') 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data())
            .toList());
  }
}