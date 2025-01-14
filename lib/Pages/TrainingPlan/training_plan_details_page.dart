import 'package:flutter/material.dart';
import 'package:user_app/Models/TrainingPlan/training_plan_model.dart';
import 'package:user_app/Models/TrainingPlan/exercise_model.dart';

class TrainingPlanDetailsPage extends StatelessWidget {
  final TrainingPlanModel trainingPlan;

  const TrainingPlanDetailsPage({required this.trainingPlan, super.key});

  @override
  Widget build(BuildContext context) {
    final sortedTrainingDays = [...trainingPlan.trainingDays];
    sortedTrainingDays.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(trainingPlan.name ?? 'Training Plan Details'),
        centerTitle: true,
      ),
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
            Text(
              'Start Date: ${trainingPlan.startDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sortedTrainingDays.length,
                itemBuilder: (context, index) {
                  final trainingDay = sortedTrainingDays[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ExpansionTile(
                      title: Text(
                        trainingDay.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exercises (${trainingDay.exercises.length}):',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: trainingDay.exercises.length,
                                itemBuilder: (context, exerciseIndex) {
                                  final exercise =
                                      trainingDay.exercises[exerciseIndex];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
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
                      ],
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
