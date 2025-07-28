import 'package:flutter/material.dart';
import "package:provider/provider";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_v2/services/auth_service.dart'; // Ensure correct path
import 'package:lost_and_found_v2/services/firestore_service.dart'; // Ensure correct path
import 'package:lost_and_found_v2/models/lost_item.dart'; // Ensure correct path
import 'package:lost_and_found_v2/screens/add_item_screen.dart';
import 'package:provider/provider.dart'; // Ensure correct path

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await _firestore.getUserRole(user.uid);
      setState(() {
        _userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user != null && _userRole == null) {
      _fetchUserRole();
    } else if (user == null && _userRole != null) {
      setState(() {
        _userRole = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lost and Found Items'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  'ID: ${user.uid.substring(0, 6)}...',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ),
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
        stream: _firestore.getLostItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No lost items found yet.'));
          } else {
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
                        if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600])),
                              ),
                            ),
                          ),
                        SizedBox(height: item.imageUrl != null && item.imageUrl!.isNotEmpty ? 10 : 0),
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
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItemScreen()),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}