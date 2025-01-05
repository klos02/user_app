import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/trainer_model.dart';

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
Future<Map<String, dynamic>> getTrainerById(String trainerId) async {
    final doc = await _firestore.collection('trainers').doc(trainerId).get();
    final data = doc.data();


    if (data == null) {
    throw Exception('Trainer not found');
  }
    return data;
  }
  
}