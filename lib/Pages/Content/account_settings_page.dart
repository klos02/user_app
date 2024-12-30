import 'package:flutter/material.dart';
import 'package:user_app/Services/Auth/auth.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Settings'),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
    );
  }
}
