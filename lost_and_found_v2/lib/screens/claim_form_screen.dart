import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_v2/models/lost_item.dart';
import 'package:lost_and_found_v2/models/claim.dart'; // NEW IMPORT
import 'package:lost_and_found_v2/services/firestore_service.dart'; // NEW IMPORT

class ClaimFormScreen extends StatefulWidget {
  final LostItem item;

  const ClaimFormScreen({Key? key, required this.item}) : super(key: key);

  @override
  _ClaimFormScreenState createState() => _ClaimFormScreenState();
}

class _ClaimFormScreenState extends State<ClaimFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  String _justification = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _submitClaim() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception('User not logged in.');
        }

        final newClaim = Claim(
          id: '', // Firestore will auto-generate
          itemId: widget.item.id,
          userId: currentUser.uid,
          justification: _justification,
          createdAt: Timestamp.now(),
        );

        await _firestoreService.addClaim(newClaim);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Claim submitted successfully!')),
        );
        Navigator.pop(context); // Go back to the ItemDetailScreen
      } catch (e) {
        setState(() {
          _errorMessage = 'Error submitting claim: $e';
        });
        print('Error submitting claim: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claiming "${widget.item.title}"'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please provide a brief justification for your claim.',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Justification',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (val) => val?.isEmpty ?? true ? 'Justification is required' : null,
                      onSaved: (val) => _justification = val ?? '',
                    ),
                    SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _submitClaim,
                      icon: Icon(Icons.send),
                      label: Text('Submit Claim', style: TextStyle(fontSize: 18)),
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
            ),
    );
  }
}
