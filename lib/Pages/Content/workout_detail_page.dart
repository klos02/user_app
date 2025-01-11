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
    trainingDays.sort((a, b) => a.date.compareTo(b.date));

    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainingPlan.name ?? 'Workout Details'),
      ),
      body: ListView.builder(
        itemCount: trainingDays.length,
        itemBuilder: (context, index) {
          final trainingDay = trainingDays[index];
          final isToday = _isSameDate(today, trainingDay.date);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Row(
                children: [
                  Text(
                    trainingDay.name,
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? Colors.blue : null,
                    ),
                  ),
                  if (isToday)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.today, color: Colors.blue),
                    ),
                ],
              ),
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
                        physics: const NeverScrollableScrollPhysics(),
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
                                    decoration: const InputDecoration(
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
                                    decoration: const InputDecoration(
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
        child: const Icon(Icons.send),
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _submitResults() async {
    final resultsToSend = _results.entries.expand((entry) {
      final exerciseKey = entry.key;
      final parts = exerciseKey.split('-');
      final trainingDayDate = parts.take(3).join('-'); // YYYY-MM-DD
      final exercise = parts.skip(3).join('-');

      final dateName = trainingDayDate;

      return entry.value.entries.map((setEntry) {
        final setIndex = setEntry.key;
        final setData = setEntry.value;

        final Map<String, dynamic> result = {
          'exercise': exercise,
          'set': setIndex + 1,
          'timestamp': Timestamp.now(),
          'dateName': dateName,
        };

        if (setData['weight'] != null && setData['weight']!.isNotEmpty) {
          result['weight'] = int.tryParse(setData['weight']!) ?? 0;
        }

        if (setData['reps'] != null && setData['reps']!.isNotEmpty) {
          result['reps'] = int.tryParse(setData['reps']!) ?? 0;
        }

        return result;
      }).where((result) =>
          result.containsKey('weight') || result.containsKey('reps'));
    }).toList();

    if (resultsToSend.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No results to submit. Please fill in the data.')),
      );
      return;
    }

    try {
      await TrainingResultService().saveResultsToAllExercises(
        userId: widget.currentUser,
        trainingPlanId: widget.trainingPlan.id!,
        results: resultsToSend,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results submitted successfully!')),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit results: $e')),
      );
    }
  }
}
