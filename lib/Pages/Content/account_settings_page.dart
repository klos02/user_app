import 'package:flutter/material.dart';
import 'package:user_app/Services/Auth/auth.dart';
import 'package:user_app/Services/Auth/users_db.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final String userId = Auth().currentUser!.uid;

  double weight = 70.0;
  double height = 176.0;
  int gymExperience = 0;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _gymExperienceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    weight = await Usersdb().getWeight(userId) ?? 70.0;
    height = await Usersdb().getHeight(userId) ?? 176.0;
    gymExperience = await Usersdb().getGymExperience(userId) ?? 0;

    _weightController.text = weight.toStringAsFixed(2);
    _heightController.text = height.toStringAsFixed(2);
    _gymExperienceController.text = gymExperience.toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Weight: ${weight.toStringAsFixed(2)} kg',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Height: ${height.toStringAsFixed(2)} cm',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Gym Experience: ${gymExperience.toString()} months',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              'Change Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        weight = double.tryParse(value) ?? weight;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        height = double.tryParse(value) ?? height;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _gymExperienceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Experience',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        gymExperience = int.tryParse(value) ?? gymExperience;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Usersdb().updateWeight(userId, weight);
                  Usersdb().updateHeight(userId, height);
                  Usersdb().updateExperience(userId, gymExperience);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your settings have been updated!')),
                  );
                },
                child: Text('Save Changes'),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  Auth().signOut();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You have been signed out.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      color: Colors.red,
                      Icons.logout,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
