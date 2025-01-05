import 'package:flutter/material.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Models/collaboration_model.dart';
import 'package:user_app/Pages/Content/workout_detail_page.dart';
import 'package:user_app/Services/collaboration_service.dart';
import 'package:user_app/Services/training_result_service.dart';
import 'package:user_app/Services/Auth/auth.dart';

class WorkoutPage extends StatelessWidget {
  final String clientId = Auth().currentUser!.uid;

  WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Workout Plan'),
      ),
      body: StreamBuilder<List<CollaborationModel>>(
        stream: CollaborationService().getCollaborationsForId(clientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No available training plans.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final collaborations = snapshot.data!;
          final trainingPlans = collaborations
              .expand((collaboration) => collaboration.trainingPlans ?? [])
              .toList();

          if (trainingPlans.isEmpty) {
            return Center(
              child: Text(
                'No training plans assigned to your account.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: trainingPlans.length,
            itemBuilder: (context, index) {
              final plan = trainingPlans[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(plan.name ?? 'Unnamed Plan'),
                  subtitle: Text(plan.description ?? 'No description'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailPage(trainingPlan: plan),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

