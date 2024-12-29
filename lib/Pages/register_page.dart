import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _repeatPasswordController = TextEditingController();

  bool _passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            _passwordField(_passwordController, 'Password'),
            SizedBox(height: 10),
            _passwordField(_repeatPasswordController, 'Confirm Password'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkPassword();
                if(_passwordsMatch){
                  _register(_emailController.text, _passwordController.text);
                } 

                if (_passwordsMatch) {
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField(
      TextEditingController _passwordController, String text) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      onChanged: (value) => checkPassword(),
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _passwordsMatch ? Colors.blueGrey : Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _passwordsMatch ? Colors.blue.shade700 : Colors.red,
          ),
        ),
      ),
    );
  }

  void checkPassword() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _repeatPasswordController.text;
    });
  }

  Future<void> _register(String email, String password) async {
    try {
      await Auth()
          .registerWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
