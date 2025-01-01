import 'package:flutter/material.dart';
import 'package:user_app/Pages/Content/collaboration_request_page.dart';
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
              final rating = (trainer['rating'] is int)
                  ? (trainer['rating'] as int).toDouble()
                  : trainer['rating'] as double? ?? 0.0;
              final nrOfRatings = trainer['nrOfRatings'] as int? ?? 0;

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  trainerName,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          if (i < rating.round()) {
                            return Icon(Icons.star,
                                color: Colors.amber, size: 18);
                          } else {
                            return Icon(Icons.star_border,
                                color: Colors.grey, size: 18);
                          }
                        }),
                        SizedBox(width: 8),
                        Text(
                          '$rating (${nrOfRatings} reviews)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollaborationRequestPage(
                          trainerName: trainerName,
                          trainerId: trainer['uid'],
                        ),
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
