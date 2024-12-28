import 'package:flutter/material.dart';
import 'package:user_app/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logged in as ${Auth().currentUser!.email}"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Auth().signOut();
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
