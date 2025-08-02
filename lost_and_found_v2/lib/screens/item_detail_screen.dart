import 'package:flutter/material.dart';
import 'package:lost_and_found_v2/models/lost_item.dart';
import 'package:lost_and_found_v2/screens/claim_form_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final LostItem item;
  final String? userRole; // NEW: The user's role is now passed in

  const ItemDetailScreen({Key? key, required this.item, this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey[600])),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                    ),
                    SizedBox(height: 12),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 12),
                    Divider(),
                    _buildDetailRow(Icons.location_on, 'Block', item.block),
                    _buildDetailRow(Icons.check_circle, 'Status', item.status),
                    if (item.claimInstructions != null && item.claimInstructions!.isNotEmpty) ...[
                      Divider(),
                      _buildDetailRow(Icons.info_outline, 'Claim Instructions', item.claimInstructions!),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Only show the "Claim Item" button if the user is not an admin
            if (userRole != 'admin')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClaimFormScreen(item: item),
                    ),
                  );
                },
                icon: Icon(Icons.note_add),
                label: Text('Claim this Item', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
