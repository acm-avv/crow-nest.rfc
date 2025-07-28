import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_v2/firebase_options.dart'; // Ensure this path matches your new project name
import 'package:lost_and_found_v2/screens/auth_screen.dart';
import 'package:lost_and_found_v2/screens/home_screen.dart';
import 'package:lost_and_found_v2/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (_, error) {
        print('StreamProvider Error: $error');
        return null;
      },
      child: MaterialApp(
        title: 'Lost and Found App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return AuthScreen();
    } else {
      return HomeScreen();
    }
  }
}