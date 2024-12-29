import 'package:flutter/material.dart';
import 'package:user_app/auth.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Auth().signOut();
        },
        child: Text('Sign Out'),
      ),
    );
  }
}