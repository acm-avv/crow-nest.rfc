import 'package:cloud_firestore/cloud_firestore.dart';

class LostItem {
  final String id;
  final String title;
  final String description;
  final String block; // e.g., Academics, Canteen, Library
  final String? imageUrl; // Optional
  final String? claimInstructions; // Optional
  final String status; // 'available', 'claimed'
  final Timestamp createdAt; // When the item was added
  final String createdBy; // User ID of the admin who added it

  LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.block,
    this.imageUrl,
    this.claimInstructions,
    this.status = 'available',
    required this.createdAt,
    required this.createdBy,
  });

  factory LostItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return LostItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      block: data['block'] ?? '',
      imageUrl: data['imageUrl'],
      claimInstructions: data['claimInstructions'],
      status: data['status'] ?? 'available',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'block': block,
      'imageUrl': imageUrl,
      'claimInstructions': claimInstructions,
      'status': status,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}