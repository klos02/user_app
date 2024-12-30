import 'package:flutter/material.dart';
import 'package:user_app/Pages/Content/account_settings_page.dart';
import 'package:user_app/Pages/Content/settings_page.dart';
import 'package:user_app/Pages/Content/subscriptions_page.dart';
import 'package:user_app/Pages/Content/workout_page.dart';
import 'package:user_app/Services/Auth/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Indeks aktualnie wybranego ekranu

  // Lista ekranów
  final List<Widget> _screens = [
    WorkoutPage(),
    SubscriptionsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Personal Trainers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
