import 'package:flutter/material.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Models/exercise_model.dart'; // Zakładając, że masz model ExerciseModel

class TrainingPlanDetailsPage extends StatelessWidget {
  final TrainingPlanModel trainingPlan;

  const TrainingPlanDetailsPage({required this.trainingPlan, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trainingPlan.name ?? 'Training Plan Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${trainingPlan.description ?? 'No description available'}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text('Start Date: ${trainingPlan.startDate.toLocal().toString().split(' ')[0]}'),

            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trainingPlan.trainingDays.length,
                itemBuilder: (context, index) {
                  final trainingDay = trainingPlan.trainingDays[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trainingDay.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Exercises (${trainingDay.exercises.length}):'),
                          
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: trainingDay.exercises.length,
                            itemBuilder: (context, exerciseIndex) {
                              final exercise =
                                  trainingDay.exercises[exerciseIndex];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.baseModel.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Description: ${exercise.baseModel.description ?? 'No description'}'),
                                      const SizedBox(height: 8),
                                      Text('Sets: ${exercise.sets}'),
                                      Text('Reps: ${exercise.reps}'),
                                      Text('Rest: ${exercise.rest} sec'),
                                      Text(
                                          'Muscle Group: ${exercise.baseModel.muscleGroup}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
