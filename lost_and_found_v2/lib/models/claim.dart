import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  final String id;
  final String itemId; // ID of the lost item being claimed
  final String userId; // UID of the user making the claim
  final String justification;
  final String status; // 'pending', 'approved', 'rejected'
  final Timestamp createdAt;

  Claim({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.justification,
    this.status = 'pending',
    required this.createdAt,
  });

  factory Claim.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Claim(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      userId: data['userId'] ?? '',
      justification: data['justification'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'userId': userId,
      'justification': justification,
      'status': status,
      'createdAt': createdAt,
    };
  }
}