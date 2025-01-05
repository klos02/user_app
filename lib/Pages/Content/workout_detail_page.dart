import 'package:flutter/material.dart';
import 'package:user_app/Models/training_plan_model.dart';

class WorkoutDetailPage extends StatefulWidget {
  final TrainingPlanModel trainingPlan;

  const WorkoutDetailPage({required this.trainingPlan, super.key});

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
                final exerciseKey = '${trainingDay.name}-${exercise.name}';

                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${exercise.description}'),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: exercise.sets, // Liczba serii
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
                                        _results[exerciseKey]![setIndex]!['weight'] =
                                            value;
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
                                        _results[exerciseKey]![setIndex]!['reps'] =
                                            value;
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
      final trainingDay = exerciseKey.split('-')[0];
      final exercise = exerciseKey.split('-')[1];

      return entry.value.entries.map((setEntry) {
        final setIndex = setEntry.key;
        final setData = setEntry.value;

        return {
          'trainingDay': trainingDay,
          'exercise': exercise,
          'set': setIndex + 1,
          'weight': setData['weight'] ?? '',
          'reps': setData['reps'] ?? '',
          'timestamp': DateTime.now().toIso8601String(),
        };
      });
    }).toList();

    
    // await TrainingResultService().saveResults(clientId, widget.trainingPlan.id, resultsToSend);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Results submitted successfully!')),
    );

    Navigator.pop(context);
  }
}
