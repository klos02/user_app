import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingResultService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveResults({
    required String userId,
    required String trainingPlanId,
    required List<Map<String, dynamic>> results,
  }) async {
    try {
      final DocumentReference trainingPlanRef =
          _firestore.collection('trainingPlans').doc(trainingPlanId);

      final planSnapshot = await trainingPlanRef.get();

      if (!planSnapshot.exists) {
        throw Exception('Training plan does not exist');
      } else {
        final List<dynamic> trainingDays = planSnapshot.get('trainingDays');
        if (trainingDays.isNotEmpty) {
          final Map<String, dynamic> firstDay = trainingDays[0];
          firstDay['results'] = results;

          await trainingPlanRef.update({
            'trainingDays': trainingDays,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw Exception('No training days found in the training plan');
        }
      }
    } catch (e) {
      throw Exception('Failed to save results: $e');
    }
  }

  Future<void> saveResultsToAllExercises({
    required String userId,
    required String trainingPlanId,
    required List<Map<String, dynamic>> results,
  }) async {
    try {
      final DocumentReference trainingPlanRef =
          _firestore.collection('trainingPlans').doc(trainingPlanId);

      final planSnapshot = await trainingPlanRef.get();

      if (!planSnapshot.exists) {
        throw Exception('Training plan does not exist');
      } else {
        final List<dynamic> trainingDays = planSnapshot.get('trainingDays');

        //print('Results for this exercise: $results');

        if (trainingDays.isNotEmpty) {
          for (var day in trainingDays) {
            final List<dynamic> exercises = day['exercises'];

            for (var exercise in exercises) {
              if (exercise != null) {
                exercise['results'] ??= [];

                //print('Results for this exercise: ${results[0]['exercise']}');

                final exerciseResults = results.where((result) {
                  return result['exercise'] == exercise['baseModel']['name'];
                }).toList();

                for (var result in exerciseResults) {
                  final existingResult = exercise['results']?.firstWhere(
                    (r) => r['set'] == result['set'],
                    orElse: () => null,
                  );

                  if (existingResult != null) {
                    existingResult['weight'] = result['weight'];
                    existingResult['reps'] = result['reps'];
                    existingResult['timestamp'] = result['timestamp'];
                  } else {
                    exercise['results'].add({
                      'set': result['set'],
                      'weight': result['weight'],
                      'reps': result['reps'],
                      'timestamp': result['timestamp'],
                    });
                  }
                }
              }
            }
          }

          await trainingPlanRef.update({
            'trainingDays': trainingDays,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw Exception('No training days found in the training plan');
        }
      }
    } catch (e) {
      throw Exception('Failed to save results to all exercises: $e');
    }
  }

  Future<List<dynamic>> getResults(String trainingPlanId) async {
    try {
      final DocumentSnapshot trainingPlanSnapshot = await _firestore
          .collection('trainingPlans')
          .doc(trainingPlanId)
          .get();

      if (!trainingPlanSnapshot.exists) {
        throw Exception('Training plan does not exist');
      }

      final trainingDays =
          trainingPlanSnapshot.get('trainingDays') as List<dynamic>? ?? [];
      trainingDays.sort((a, b) => a['dayNumber'].compareTo(b['dayNumber']));
      return trainingDays;
    } catch (e) {
      throw Exception('Failed to fetch results: $e');
    }
  }
}
