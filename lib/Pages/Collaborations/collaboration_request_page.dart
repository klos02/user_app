import 'package:flutter/material.dart';
import 'package:user_app/Models/TrainerClients/request_model.dart';
import 'package:user_app/Services/Auth/auth.dart';
import 'package:user_app/Services/Auth/users_db.dart';
import 'package:user_app/Services/Collaborations/requests_service.dart';

class CollaborationRequestPage extends StatefulWidget {
  final String trainerName;
  final String trainerId;

  CollaborationRequestPage({
    super.key,
    required this.trainerName,
    required this.trainerId,
  });

  @override
  _CollaborationRequestPageState createState() =>
      _CollaborationRequestPageState();
}

class _CollaborationRequestPageState extends State<CollaborationRequestPage> {
  String? selectedGoal;
  String? selectedSessionsPerWeek;
  String? selectedUpdateFrequency;
  TextEditingController _additionalNotesController = TextEditingController();
  String userId = Auth().currentUser!.uid;
  String? name;
  late String trainerId;

  @override
  void initState() {
    super.initState();
    trainerId = widget.trainerId;
    _loadData();
  }

  _loadData() async {
    name = await Usersdb().getName(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collaborate with ${widget.trainerName}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _goalTile('Increase Mass', Icons.fitness_center),
                _goalTile('Increase Strength', Icons.shield),
                _goalTile('Lose Weight', Icons.local_fire_department),
              ],
            ),
            SizedBox(height: 24),
            _dropdownSection(
              title: 'Sessions per Week',
              hint: 'Select sessions per week',
              items: List.generate(7, (index) => '${index + 1} sessions'),
              value: selectedSessionsPerWeek?.toString(),
              onChanged: (value) {
                setState(() {
                  selectedSessionsPerWeek = value!;
                });
              },
            ),
            SizedBox(height: 24),
            _dropdownSection(
              title: 'Update Frequency',
              hint: 'Select update frequency',
              items: ['Weekly', 'Bi-weekly', 'Monthly'],
              value: selectedUpdateFrequency,
              onChanged: (value) {
                setState(() {
                  selectedUpdateFrequency = value;
                });
              },
            ),
            SizedBox(height: 24),
            Text(
              'Additional Notes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _additionalNotesController,
              decoration: InputDecoration(
                hintText: 'Write any additional details...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _sendRequest,
              child: Center(
                child: Text(
                  'Send Request',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalTile(String goal, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedGoal == goal
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selectedGoal == goal
              ? [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 10)
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: selectedGoal == goal
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            SizedBox(height: 8),
            Text(
              goal,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selectedGoal == goal
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownSection({
    required String title,
    required String hint,
    required List<String> items,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          hint: Text(hint),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _sendRequest() async {
    if (selectedGoal == null ||
        selectedSessionsPerWeek == null ||
        selectedUpdateFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (await RequestsService().hasUserSentRequest(userId, widget.trainerId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already sent a request to this trainer'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (await RequestsService().userHasActiveCollaboration(userId, widget.trainerId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are already collaborating with this trainer'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    try {
      final requestModel = RequestModel(
        fromId: userId,
        toId: trainerId,
        goal: selectedGoal!,
        sessionsPerWeek: int.tryParse(selectedSessionsPerWeek!.split(' ')[0])!,
        updateFrequency: selectedUpdateFrequency!,
        additionalNotes: _additionalNotesController.text,
        fromName: name!,
      );

      RequestsService().sendRequest(requestModel.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Collaboration request sent!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred, please try again'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
