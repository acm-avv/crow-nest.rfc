import 'package:flutter/material.dart';
import 'package:lost_and_found_v2/services/auth_service.dart'; // Ensure correct path
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  String error = '';
  bool isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    User? user = await _auth.signInWithGoogle();
    setState(() {
      isLoading = false;
    });

    if (user == null) {
      setState(() {
        error = 'Google Sign-In failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In to Lost and Found'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Lost and Found!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                    icon: Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      height: 24.0,
                      width: 24.0,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.account_circle, color: Colors.white),
                    ),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: _signInWithGoogle,
                  ),
            SizedBox(height: 20.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}