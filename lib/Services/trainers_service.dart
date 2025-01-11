import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Models/trainer_model.dart';

class TrainersService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTrainers() {
    return _firestore
        .collection('trainers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Map<String, dynamic>> getTrainerById(String trainerId) async {
    final doc = await _firestore.collection('trainers').doc(trainerId).get();
    final data = doc.data();

    if (data == null) {
      throw Exception('Trainer not found');
    }
    return data;
  }

  

  Future<void> updateAverageRating(String trainerId, double newRating, String userId) async {
    try {
      final doc = await _firestore.collection('trainers').doc(trainerId).get();
      final data = doc.data();

      if(await hasUserRatedTrainer(trainerId, userId)) {
        throw Exception('User has already rated this trainer');
      }

      if (data == null) {
        throw Exception('Trainer not found');
      }

      double ratingSum = data['ratingSum'] ?? 0;
      int nrOfRatings = data['nrOfRatings'] ?? 0;

      if (ratingSum == 0 || nrOfRatings == 0) {
        await _firestore.collection('trainers').doc(trainerId).update({
          'rating': 0,
          'nrOfRatings': 0,
          'ratingSum': 0,
        });
      }

      ratingSum += newRating;
      nrOfRatings++;

      final avgRating = ratingSum / nrOfRatings;

      await _firestore.collection('trainers').doc(trainerId).update({
        'rating': avgRating,
        'nrOfRatings': nrOfRatings,
        'ratingSum': ratingSum,
      });

      await _firestore.collection('users').doc(userId).update({
        'givenRatingTo': FieldValue.arrayUnion([trainerId]),
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<bool> hasUserRatedTrainer(String trainerId, String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData == null) {
      throw Exception('User not found');
    }

    final ratedTrainers = userData['givenRatingTo'] as List<dynamic>?;

    if (ratedTrainers == null) {
      return false;
    }

    return ratedTrainers.contains(trainerId);
  }
}
