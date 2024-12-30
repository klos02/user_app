import 'package:flutter/material.dart';
import 'package:user_app/Pages/home_page.dart';
import 'package:user_app/Pages/login_page.dart';
import 'package:user_app/Services/Auth/auth.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const HomePage();
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return LoginPage();
        }
      },
    );
  }
}