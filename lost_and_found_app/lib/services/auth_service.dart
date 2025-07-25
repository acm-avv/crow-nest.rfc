import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Register with Email and Password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error (Register): ${e.message}');
      // You can throw a custom exception or return null and handle the error message in the UI
      return null;
    } catch (e) {
      print('General Error (Register): $e');
      return null;
    }
  }

  // Sign in with Email and Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error (Sign In): ${e.message}');
      return null;
    } catch (e) {
      print('General Error (Sign In): $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}