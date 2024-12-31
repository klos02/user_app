import 'package:flutter/material.dart';

class CollaborationRequestPage extends StatefulWidget {
  final String trainerName;
  final String trainerId;

  CollaborationRequestPage({
    required this.trainerName,
    required this.trainerId,
  });

  @override
  _CollaborationRequestPageState createState() =>
      _CollaborationRequestPageState();
}

class _CollaborationRequestPageState extends State<CollaborationRequestPage> {
  String? selectedGoal;
  int? selectedSessionsPerWeek;
  String? selectedUpdateFrequency;
  TextEditingController _additionalNotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Collaborate with ${widget.trainerName}')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your goal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _goalTile('Increase Mass'),
                _goalTile('Increase Strength'),
                _goalTile('Lose Weight'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Sessions per week:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedSessionsPerWeek,
              onChanged: (value) {
                setState(() {
                  selectedSessionsPerWeek = value;
                });
              },
              hint: Text('Select sessions per week'),
              items: List.generate(7, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1} sessions'),
                );
              }),
            ),
            SizedBox(height: 16),
            Text(
              'Update frequency for your plan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedUpdateFrequency,
              onChanged: (value) {
                setState(() {
                  selectedUpdateFrequency = value;
                });
              },
              hint: Text('Select update frequency'),
              items: ['Weekly', 'Bi-weekly', 'Monthly']
                  .map((frequency) => DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Additional Notes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _additionalNotesController,
              decoration: InputDecoration(
                labelText: 'Any additional notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //TODO: Logika wysyłania prośby o współpracę
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

  Widget _goalTile(String goal) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedGoal == goal ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedGoal == goal ? Colors.blue : Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            goal,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedGoal == goal ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
