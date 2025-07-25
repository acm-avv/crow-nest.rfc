import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // To get the current user for sign out
import 'package:lost_and_found_app/services/auth_service.dart';
import 'package:lost_and_found_app/services/firestore_service.dart';
import 'package:lost_and_found_app/models/lost_item.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); // Get current user from Provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Lost and Found Items'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: StreamBuilder<List<LostItem>>(
        stream: _firestore.getLostItems(), // Listen to the stream of lost items
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No lost items found yet.'));
          } else {
            // Display the list of items
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                LostItem item = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              'Block: ${item.block}',
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Status: ${item.status}',
                          style: TextStyle(
                            fontSize: 14,
                            color: item.status == 'available' ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Add more details or action buttons here (e.g., "Claim Item")
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // Floating action button for adding items (for admin later)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For MVP, just print a message. Later, navigate to an AddItemScreen.
          print('Add new item button pressed!');
          // Example of adding a dummy item (remove later)
          _firestore.addLostItem(
            LostItem(
              id: '', // Firestore will assign an ID
              title: 'Dummy Item ${DateTime.now().second}',
              description: 'This is a test item added by ${user?.uid ?? 'unknown'}.',
              block: 'Canteen',
              createdAt: Timestamp.now(),
              createdBy: user?.uid ?? 'anonymous',
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
