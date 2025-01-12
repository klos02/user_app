import 'package:flutter/material.dart';
import 'package:user_app/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Polish', 'Spanish'];

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: const Text('Change Theme'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => MyApp.of(context).toggleTheme(true),
                      icon: Icon(Icons.sunny),
                    ),
                    IconButton(
                      onPressed: () => MyApp.of(context).toggleTheme(false),
                      icon: Icon(Icons.nightlight_round),
                    ),
                  ],
                )),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
