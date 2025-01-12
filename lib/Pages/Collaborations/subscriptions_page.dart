import 'package:flutter/material.dart';
import 'package:user_app/Pages/Collaborations/collaboration_request_page.dart';
import 'package:user_app/Services/Collaborations/trainers_service.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final TrainersService _trainersService = TrainersService();
  String searchQuery = '';
  bool sortByRating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sort by rating'),
                Switch(
                  value: sortByRating,
                  onChanged: (value) {
                    setState(() {
                      sortByRating = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
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

                var trainers = snapshot.data!;

                if (searchQuery.isNotEmpty) {
                  trainers = trainers
                      .where((trainer) => (trainer['name'] ?? 'Unknown')
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                }

                if (sortByRating) {
                  trainers.sort((a, b) {
                    final ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
                    final ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
                    return ratingB.compareTo(ratingA);
                  });
                }

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
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < rating.round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: i < rating.round()
                                          ? Colors.amber
                                          : Colors.grey,
                                      size: 18,
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  '${rating.toStringAsFixed(2)} ($nrOfRatings reviews)',
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
          ),
        ],
      ),
    );
  }
}
