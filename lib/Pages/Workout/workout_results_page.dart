import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Models/TrainingPlan/training_plan_model.dart';
import 'package:user_app/Services/TrainingPlan/training_result_service.dart';

class WorkoutResultsPage extends StatefulWidget {
  final TrainingPlanModel trainingPlan;

  const WorkoutResultsPage({super.key, required this.trainingPlan});

  @override
  _WorkoutResultsPageState createState() => _WorkoutResultsPageState();
}

class _WorkoutResultsPageState extends State<WorkoutResultsPage> {
  final TrainingResultService _trainingResultService = TrainingResultService();
  late Future<List<dynamic>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = _trainingResultService.getResults(widget.trainingPlan.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results: ${widget.trainingPlan.name ?? 'Unnamed Plan'}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No results found for this training plan.',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          final trainingDays = snapshot.data!;
          trainingDays.sort((a, b) {
            final aDate = (a['date'] as Timestamp).toDate();
            final bDate = (b['date'] as Timestamp).toDate();
            return aDate.compareTo(bDate);
          });

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: trainingDays.length,
            itemBuilder: (context, dayIndex) {
              final day = trainingDays[dayIndex];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Text(
                    day['name'] ?? 'Unnamed Day',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  children: (day['exercises'] as List<dynamic>).map((exercise) {
                    final results = exercise['results'] as List<dynamic>? ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['baseModel']['name'] ?? 'Unnamed Exercise',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Column(
                            children: results.map<Widget>((result) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Set ${result['set']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${result['reps']} reps @ ${result['weight']} kg',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  Text(
                                    'Rest: ${exercise['rest']}s',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 12.0),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
