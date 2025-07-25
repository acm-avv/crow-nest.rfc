import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_app/models/lost_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get a stream of all lost items
  Stream<List<LostItem>> getLostItems() {
    return _db.collection('items')
        .snapshots() // Listen for real-time updates
        .map((snapshot) => snapshot.docs.map((doc) => LostItem.fromFirestore(doc)).toList());
  }

  // Add a new lost item (for admin later)
  Future<void> addLostItem(LostItem item) async {
    try {
      await _db.collection('items').add(item.toFirestore());
      print('Item added successfully!');
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  // Update a lost item (for admin later)
  Future<void> updateLostItem(LostItem item) async {
    try {
      await _db.collection('items').doc(item.id).update(item.toFirestore());
      print('Item updated successfully!');
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  // Delete a lost item (for admin later)
  Future<void> deleteLostItem(String itemId) async {
    try {
      await _db.collection('items').doc(itemId).delete();
      print('Item deleted successfully!');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}