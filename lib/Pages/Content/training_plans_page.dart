import 'package:flutter/material.dart';
import 'package:user_app/Models/trainer_model.dart';
import 'package:user_app/Models/training_plan_model.dart';
import 'package:user_app/Models/collaboration_model.dart';
import 'package:user_app/Services/collaboration_service.dart';
import 'package:user_app/Services/trainers_service.dart';
import 'package:user_app/Services/training_plan_service.dart';
import 'package:user_app/Pages/Content/training_plan_details_page.dart';
import 'package:user_app/Services/Auth/auth.dart';

class TrainingPlansPage extends StatelessWidget {
  final String clientId = Auth().currentUser!.uid;
  //late TrainerModel trainer;

  TrainingPlansPage({super.key});

  Future<String> getTrainerName(String trainerId) async {
    final trainer = await TrainersService().getTrainerById(trainerId);
    final name = await trainer['name'];
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Training Plans'),
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
                'No collaborations found.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final collaborations = snapshot.data!;

          if (collaborations.isEmpty) {
            return Center(
              child: Text(
                'No available training plans.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: collaborations.length,
            itemBuilder: (context, index) {
              final collaboration = collaborations[index];
              final trainingPlans = collaboration.trainingPlans ?? [];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: FutureBuilder<String>(
                    future: getTrainerName(collaboration.toId),
                    builder: (context, trainerSnapshot) {
                      if (trainerSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text('Loading trainer...');
                      } else if (trainerSnapshot.hasError) {
                        return Text('Error: ${trainerSnapshot.error}');
                      } else if (!trainerSnapshot.hasData) {
                        return Text('Unknown Trainer');
                      } else {
                        return Text(
                          "Creator: ${trainerSnapshot.data!}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  subtitle: Text('Goal: ${collaboration.goal}'),
                  children: [
                    if (trainingPlans.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No training plans available.'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: trainingPlans.length,
                        itemBuilder: (context, planIndex) {
                          final plan = trainingPlans[planIndex];
                          return ListTile(
                            title: Text(plan.name ?? 'Unnamed Plan'),
                            subtitle:
                                Text(plan.description ?? 'No description'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainingPlanDetailsPage(
                                      trainingPlan: plan, ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
