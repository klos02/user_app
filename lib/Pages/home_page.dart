import 'package:flutter/material.dart';
import 'package:user_app/Pages/Content/settings_page.dart';
import 'package:user_app/Pages/Content/subscriptions_page.dart';
import 'package:user_app/Pages/Content/workout_page.dart';
import 'package:user_app/auth.dart';

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
        title: Text("Logged in as ${Auth().currentUser!.email}"),
      ),
      body: _screens[_currentIndex], // Wyświetlany ekran zależy od indeksu
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
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