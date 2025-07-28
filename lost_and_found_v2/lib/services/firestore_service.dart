import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_and_found_v2/models/lost_item.dart'; // Ensure correct path
import 'dart:io'; // For File type

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<LostItem>> getLostItems() {
    return _db.collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LostItem.fromFirestore(doc)).toList());
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage(File imageFile, String itemId) async {
    try {
      final storageRef = _storage.ref().child('item_images').child('$itemId.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add a new lost item (returns DocumentReference to get the ID)
  Future<DocumentReference> addLostItem(LostItem item) async {
    try {
      final docRef = await _db.collection('items').add(item.toFirestore());
      print('Item added successfully with ID: ${docRef.id}');
      return docRef;
    } catch (e) {
      print('Error adding item: $e');
      rethrow; // Re-throw to propagate the error
    }
  }

  // Update a lost item
  Future<void> updateLostItem(LostItem item) async {
    try {
      await _db.collection('items').doc(item.id).update(item.toFirestore());
      print('Item updated successfully!');
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  // Delete a lost item
  Future<void> deleteLostItem(String itemId) async {
    try {
      // Optionally delete the image from storage first
      // await _storage.ref().child('item_images').child('$itemId.jpg').delete();
      await _db.collection('items').doc(itemId).delete();
      print('Item deleted successfully!');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Get a user's role
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}