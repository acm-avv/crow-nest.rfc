import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAuthenticating = false;

  Future<void> _signInWithMicrosoft() async {
    setState(() {
      isAuthenticating = true;
    });

    try {
      final provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters({
        "tenant": "9701167d-24a6-4a8c-b242-b5c6a8bd1fa1",
      });
      await FirebaseAuth.instance.signInWithProvider(provider);
    } catch (e) {
      // Handle error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $e')),
      );
    } finally {
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: isAuthenticating ? null : _signInWithMicrosoft,
              icon: const Icon(FontAwesomeIcons.microsoft),
              label: const Text("Sign in with Microsoft"),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}