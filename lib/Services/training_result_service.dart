import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingResultService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveResults(String clientId, String trainingPlanId, List<Map<String, String>> results) async {
    final batch = _firestore.batch();
    final resultsCollection = _firestore.collection('clients').doc(clientId).collection('trainingPlans').doc(trainingPlanId).collection('results');

    for (final result in results) {
      batch.set(resultsCollection.doc(), result);
    }

    await batch.commit();
  }
}