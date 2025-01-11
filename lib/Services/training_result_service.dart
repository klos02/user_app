import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/Services/collaboration_service.dart';

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

        if (trainingDays.isNotEmpty) {
          for (var day in trainingDays) {
            final List<dynamic> exercises = day['exercises'];

            for (var exercise in exercises) {
              if (exercise != null) {
                exercise['results'] ??= [];

                final exerciseResults = results.where((result) {
                  final dateName = result['dateName'];

                  return result['exercise'] == exercise['baseModel']['name'] && exercise['dateName'] == dateName;
                }).toList();

                for (var result in exerciseResults) {
                  final existingResultIndex = exercise['results']
                      .indexWhere((r) => r['set'] == result['set']);

                  if (existingResultIndex != -1) {
                    final existingResult =
                        exercise['results'][existingResultIndex];
                    if (result.containsKey('weight')) {
                      existingResult['weight'] = result['weight'];
                    }
                    if (result.containsKey('reps')) {
                      existingResult['reps'] = result['reps'];
                    }
                    existingResult['timestamp'] = result['timestamp'];
                  } else {
                    exercise['results'].add({
                      'set': result['set'],
                      if (result.containsKey('weight'))
                        'weight': result['weight'],
                      if (result.containsKey('reps')) 'reps': result['reps'],
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

          await CollaborationService().addTrainingPlanToCollaborationFromFirebase(trainingPlanId);
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
      //trainingDays.sort((a, b) => a['dayNumber'].compareTo(b['dayNumber']));
      return trainingDays;
    } catch (e) {
      throw Exception('Failed to fetch results: $e');
    }
  }

  
}
