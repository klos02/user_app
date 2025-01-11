import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Services/training_result_service.dart';

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
        title: Text('Results: ${widget.trainingPlan.name ?? 'Unnamed Plan'}'),
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
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final trainingDays = snapshot.data!;
          trainingDays.sort((a, b){
            final aDate = (a['date'] as Timestamp).toDate();
            final bDate = (b['date'] as Timestamp).toDate();
            return aDate.compareTo(bDate);  
          });
          return ListView.builder(
            itemCount: trainingDays.length,
            itemBuilder: (context, dayIndex) {
              final day = trainingDays[dayIndex];
              return ExpansionTile(
                title: Text(day['name'] ?? 'Unnamed Day'),
                children: (day['exercises'] as List<dynamic>).map((exercise) {
                  final results = exercise['results'] as List<dynamic>? ?? [];
                  return ListTile(
                    title: Text(
                        exercise['baseModel']['name'] ?? 'Unnamed Exercise'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: results.map((result) {
                        return Text(
                            'Set ${result['set']}: ${result['reps']} reps @ ${result['weight']}kg (Rest: ${exercise['rest']}s)');
                      }).toList(),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
