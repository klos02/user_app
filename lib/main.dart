import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey ),
        
        
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
           focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
        ),
        useMaterial3: true,
      ),
      home: WidgetTree(),
      debugShowCheckedModeBanner: false,
    );
  }
}
