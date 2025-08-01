import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_v2/models/lost_item.dart';
import 'package:lost_and_found_v2/services/firestore_service.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  String _title = '';
  String _description = '';
  String _block = 'Academics';
  String _claimInstructions = '';
  File? _imageFile;

  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _blocks = ['Academics', 'Canteen', 'Library', 'Hostel', 'Other'];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _errorMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
      print('Error picking image: $e');
    }
  }

  Future<void> _submitItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_imageFile == null) {
        setState(() {
          _errorMessage = 'Please select an image for the item.';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          setState(() {
            _errorMessage = 'User not logged in.';
            _isLoading = false;
          });
          return;
        }

        // Generate a new document ID for the item *before* adding it to Firestore
        String newDocId = FirebaseFirestore.instance.collection('items').doc().id;

        // Upload the image first
        String? imageUrl = await _firestoreService.uploadImage(_imageFile!, newDocId);

        if (imageUrl == null) {
          setState(() {
            _errorMessage = 'Image upload failed. Please try again.';
            _isLoading = false;
          });
          return;
        }

        // Create the LostItem object with the generated ID and image URL
        final newItem = LostItem(
          id: newDocId, // Use the pre-generated ID
          title: _title,
          description: _description,
          block: _block,
          imageUrl: imageUrl, // Include the uploaded image URL
          claimInstructions: _claimInstructions,
          status: 'available',
          createdAt: Timestamp.now(),
          createdBy: currentUser.uid,
        );

        // Call the NEW setLostItem method to add the item with the pre-generated ID
        await _firestoreService.setLostItem(newItem);


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lost item added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = 'Error adding item: $e';
        });
        print('Error adding item: $e');
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
        title: Text('Add New Lost Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
                                  SizedBox(height: 10),
                                  Text(
                                    'Tap to pick image',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty && _imageFile == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title (e.g., Blue Water Bottle)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (val) => val?.isEmpty ?? true ? 'Please enter a title' : null,
                      onSaved: (val) => _title = val ?? '',
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 3,
                      validator: (val) => val?.isEmpty ?? true ? 'Please enter a description' : null,
                      onSaved: (val) => _description = val ?? '',
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Block',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      value: _block,
                      items: _blocks.map((String block) {
                        return DropdownMenuItem<String>(
                          value: block,
                          child: Text(block),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _block = newValue!;
                        });
                      },
                      onSaved: (val) => _block = val ?? '',
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Claim Instructions (e.g., Contact security office)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 2,
                      onSaved: (val) => _claimInstructions = val ?? '',
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Add Item',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: _submitItem,
                    ),
                    SizedBox(height: 10),
                    if (_errorMessage.isNotEmpty && _imageFile != null)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
