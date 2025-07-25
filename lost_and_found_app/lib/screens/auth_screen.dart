import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_app/services/auth_service.dart'; // Import your auth service
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool showSignIn = true; // Toggle between sign-in and register
  bool isLoading = false;

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset(); // Clear form fields
      error = '';
      showSignIn = !showSignIn;
    });
  }

/*************  ✨ Windsurf Command ⭐  *************/
  /// Authenticates the user either by signing in or registering based on the 
  /// current view state. Displays an error message if authentication fails.
  /// 
  /// This method validates the form inputs, sets the loading state, and attempts
  /// authentication using the provided email and password. If `showSignIn` is 
  /// true, it attempts to sign in the user; otherwise, it attempts to register 
  /// the user. If authentication fails, an error message is displayed.

/*******  3c0b7601-be6c-480b-86dc-eb1d01ed3c6f  *******/
  Future<void> _authenticate() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
        error = '';
      });
      User? user;
      if (showSignIn) {
        user = await _auth.signInWithEmailAndPassword(email, password);
      } else {
        user = await _auth.registerWithEmailAndPassword(email, password);
      }

      setState(() {
        isLoading = false;
      });

      if (user == null) {
        setState(() {
          error = 'Authentication failed. Please check your credentials.';
        });
      }
      // If user is not null, the stream in main.dart will handle navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showSignIn ? 'Sign In' : 'Register'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (val) => val?.isEmpty ?? true ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (val) => (val?.length ?? 0) < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        showSignIn ? 'Sign In' : 'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: _authenticate,
                    ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                onPressed: toggleView,
                child: Text(
                  showSignIn ? 'Need an account? Register' : 'Already have an account? Sign In',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}