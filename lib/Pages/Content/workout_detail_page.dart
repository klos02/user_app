import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Services/Auth/auth.dart';
import 'package:user_app/Services/training_result_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final TrainingPlanModel trainingPlan;
  final currentUser = Auth().currentUser!.uid;

  WorkoutDetailPage({required this.trainingPlan, super.key});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final Map<String, Map<int, Map<String, String>>> _results = {};

  @override
  Widget build(BuildContext context) {
    final trainingDays = widget.trainingPlan.trainingDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainingPlan.name ?? 'Workout Details'),
      ),
      body: ListView.builder(
        itemCount: trainingDays.length,
        itemBuilder: (context, index) {
          final trainingDay = trainingDays[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(trainingDay.name),
              subtitle: Text('Exercises: ${trainingDay.exercises.length}'),
              children: trainingDay.exercises.map((exercise) {
                final exerciseKey =
                    '${trainingDay.name}-${exercise.baseModel.name}';

                return ListTile(
                  title: Text(exercise.baseModel.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${exercise.baseModel.description}'),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: exercise.sets,
                        itemBuilder: (context, setIndex) {
                          final setKey = '${exerciseKey}-set${setIndex + 1}';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Text('Set ${setIndex + 1}: '),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Weight (kg)',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _results[exerciseKey] ??= {};
                                        _results[exerciseKey]![setIndex] ??= {};
                                        _results[exerciseKey]![setIndex]![
                                            'weight'] = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Reps',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _results[exerciseKey] ??= {};
                                        _results[exerciseKey]![setIndex] ??= {};
                                        _results[exerciseKey]![setIndex]![
                                            'reps'] = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitResults,
        child: Icon(Icons.send),
      ),
    );
  }

  void _submitResults() async {
    final resultsToSend = _results.entries.expand((entry) {
      final exerciseKey = entry.key;
      final exercise = exerciseKey.split('-').last;

      return entry.value.entries.map((setEntry) {
        final setIndex = setEntry.key;
        final setData = setEntry.value;

        return {
          'exercise': exercise,
          'set': setIndex + 1,
          'weight': int.tryParse(setData['weight']!) ?? 0,
          'reps': int.tryParse(setData['reps']!) ?? 0,
          'timestamp': Timestamp.now(),
        };
      });
    }).toList();

    //print('Results for this exercise: $resultsToSend');

    try {
      await TrainingResultService().saveResultsToAllExercises(
        userId: widget.currentUser,
        trainingPlanId: widget.trainingPlan.id!,
        results: resultsToSend,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Results submitted successfully!')),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit results: $e')),
      );
    }
  }
}
