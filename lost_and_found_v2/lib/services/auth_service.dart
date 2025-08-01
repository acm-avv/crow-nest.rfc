import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign-In cancelled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Use a transaction to safely check for and update the user document
        await _firestore.runTransaction((transaction) async {
          final userDocRef = _firestore.collection('users').doc(user.uid);
          final userDocSnapshot = await transaction.get(userDocRef);

          // Get the current data, or an empty map if the document doesn't exist
          final currentData = userDocSnapshot.data() ?? {};

          // Data to be merged/updated
          Map<String, dynamic> newData = {
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
          };

          // Only set the default role if the 'role' field does not exist
          if (!currentData.containsKey('role')) {
            newData['role'] = 'user';
            newData['createdAt'] = FieldValue.serverTimestamp();
          }

          // Write the data back to Firestore
          transaction.set(userDocRef, newData, SetOptions(merge: true));
        });
      }

      print('Successfully signed in with Google: ${user?.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error (Google Sign In): ${e.message}');
      return null;
    } catch (e) {
      print('General Error (Google Sign In): $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('User signed out.');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
