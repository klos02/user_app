import 'package:flutter/material.dart';

class CollaborationRequestPage extends StatelessWidget {
  final String trainerName;
  final String trainerId;

  CollaborationRequestPage({
    required this.trainerName,
    required this.trainerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Collaboration with $trainerName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a request to collaborate with $trainerName.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //TODO
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Collaboration request sent!')),
                );
              },
              child: Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
