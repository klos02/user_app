import 'package:flutter/material.dart';
import 'package:user_app/Models/TrainerClients/collaboration_model.dart';
import 'package:user_app/Models/TrainingPlan/training_plan_model.dart';
import 'package:user_app/Pages/Collaborations/rating_dialog.dart';
import 'package:user_app/Services/Collaborations/collaboration_service.dart';
import 'package:user_app/Services/Collaborations/trainers_service.dart';
import 'package:user_app/Pages/Workout/workout_detail_page.dart';
import 'package:user_app/Pages/Workout/workout_results_page.dart';
import 'package:user_app/Pages/TrainingPlan/training_plan_details_page.dart';
import 'package:user_app/Services/Auth/auth.dart';

class TrainingPlansPage extends StatefulWidget {
  @override
  _TrainingPlansPageState createState() => _TrainingPlansPageState();
}

class _TrainingPlansPageState extends State<TrainingPlansPage> {
  final String clientId = Auth().currentUser!.uid;

  Future<String> getTrainerName(String trainerId) async {
    final trainer = await TrainersService().getTrainerById(trainerId);
    return trainer['name'] ?? 'Unknown Trainer';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Your Collaborations'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Training Plans'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStreamView(
              stream: CollaborationService().getCollaborationsForId(clientId),
              emptyMessage: 'No collaborations available',
              builder: (collaborations) => ListView(
                padding: EdgeInsets.all(16),
                children:
                    collaborations.map((c) => _buildTrainerCard(c)).toList(),
              ),
            ),
            _buildStreamView(
              stream: CollaborationService().getCollaborationsForId(clientId),
              emptyMessage: 'No training plans available',
              builder: (collaborations) {
                final trainingPlans = collaborations
                    .expand((c) => c.trainingPlans ?? [])
                    .toList();
                return ListView(
                  padding: EdgeInsets.all(16),
                  children:
                      trainingPlans.map((p) => _buildPlanCard(p)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamView<T>({
    required Stream<List<T>> stream,
    required String emptyMessage,
    required Widget Function(List<T>) builder,
  }) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(emptyMessage));
        }
        return builder(snapshot.data!);
      },
    );
  }

  Widget _buildTrainerCard(CollaborationModel collaboration) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: FutureBuilder<String>(
          future: getTrainerName(collaboration.toId),
          builder: (context, snapshot) {
            return Text(snapshot.data ?? '',
                style: TextStyle(fontWeight: FontWeight.bold));
          },
        ),
        subtitle: Text('Goal: ${collaboration.goal}'),
        trailing: ElevatedButton.icon(
          onPressed: () => _showRatingDialog(collaboration.toId),
          label: Text('Rate', style: TextStyle(fontSize: 12)),
          icon: Icon(Icons.star, size: 16),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(80, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),
        children: (collaboration.trainingPlans ?? [])
            .map((plan) => ListTile(
                  title: Text(plan.name ?? 'Unnamed Plan'),
                  subtitle: Text(plan.description ?? 'No description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TrainingPlanDetailsPage(trainingPlan: plan),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _showRatingDialog(String trainerId) async {
    final trainerName = await getTrainerName(trainerId);
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => RatingDialog(
          trainerId: trainerId,
          trainerName: trainerName,
        ),
      );
    }
  }

  Widget _buildPlanCard(TrainingPlanModel plan) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name ?? 'Unnamed Plan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  plan.description ?? 'No description',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkoutDetailPage(trainingPlan: plan),
                        ),
                      ),
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Workout'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              WorkoutResultsPage(trainingPlan: plan),
                        ),
                      ),
                      icon: Icon(Icons.assessment_outlined),
                      label: Text('Results'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.blue),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrainingPlanDetailsPage(trainingPlan: plan),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
