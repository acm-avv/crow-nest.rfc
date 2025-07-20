import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('UID: ${user?.uid ?? "N/A"}'),
          Text('Display Name: ${user?.displayName ?? "N/A"}'),
          Text('Email: ${user?.email ?? "N/A"}'),
        ],
      ),
    );
  }
}