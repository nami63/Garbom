import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/auth/register.dart'; // Import your AuthService here

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService(); // Initialize your AuthService
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        userData = await _authService.getUserData(user!.uid);
        if (userData != null) {
          // Populate text fields with user data
          _nameController.text = userData!['name'] ?? '';
          _phoneController.text = userData!['phoneNumber'] ?? '';
          _addressController.text = userData!['address'] ?? '';
          _stateController.text = userData!['state'] ?? '';
          _pinCodeController.text = userData!['pinCode'] ?? '';
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
      setState(() {});
    }
  }

  Future<void> updateUserData() async {
    if (user != null) {
      try {
        // Update user data in Firestore
        await _authService.updateUserData(user!.uid, {
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
          'state': _stateController.text,
          'pinCode': _pinCodeController.text,
        });
        // Fetch updated user data after update
        fetchUserData();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Error updating user data: $e');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 40), // To add some space at the top
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 107, 100, 237),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Text fields for editing user profile data
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _stateController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'State',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pinCodeController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Pin Code',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateUserData,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }
}
