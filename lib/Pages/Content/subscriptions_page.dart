import 'package:flutter/material.dart';
import 'package:user_app/Services/trainers_service.dart';

class SubscriptionsPage extends StatelessWidget {
  final TrainersService _trainersService = TrainersService();

  SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _trainersService.getTrainers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No trainers found.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final trainers = snapshot.data!;

          return ListView.builder(
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              final trainer = trainers[index];
              final trainerName = trainer['name'] ?? 'Unknown';

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(trainerName, style: TextStyle(fontSize: 18)),
                subtitle: Text('Trainer'),
              );
            },
          );
        },
      ),
    );
  }
}
