import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_and_found_v2/models/lost_item.dart';
import 'package:lost_and_found_v2/models/claim.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<LostItem>> getLostItems() {
    return _db.collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LostItem.fromFirestore(doc)).toList());
  }

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

  // UPDATED: This method is now specifically for adding a new item with a SET operation
  Future<void> setLostItem(LostItem item) async {
    try {
      await _db.collection('items').doc(item.id).set(item.toFirestore());
      print('Item added/set successfully with ID: ${item.id}');
    } catch (e) {
      print('Error setting item: $e');
      rethrow;
    }
  }

  // This method remains for updating existing items
  Future<void> updateLostItem(LostItem item) async {
    try {
      await _db.collection('items').doc(item.id).update(item.toFirestore());
      print('Item updated successfully!');
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<void> deleteLostItem(String itemId) async {
    try {
      await _db.collection('items').doc(itemId).delete();
      print('Item deleted successfully!');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<void> addClaim(Claim claim) async {
    try {
      await _db.collection('claims').add(claim.toFirestore());
      print('Claim submitted successfully!');
    } catch (e) {
      print('Error submitting claim: $e');
    }
  }
}
