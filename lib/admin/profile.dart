import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/auth/register.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

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
      userData = await _authService.getUserData(user!.uid);
      if (userData != null) {
        _nameController.text = userData!['name'];
        _phoneController.text = userData!['phoneNumber'];
        _addressController.text = userData!['address'];
        _stateController.text = userData!['state'];
        _pinCodeController.text = userData!['pinCode'];
      }
      setState(() {});
    }
  }

  Future<void> updateUserData() async {
    if (user != null) {
      await _authService.updateUserData(user!.uid, {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'address': _addressController.text,
        'state': _stateController.text,
        'pinCode': _pinCodeController.text,
      });
      fetchUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _pinCodeController,
              decoration: const InputDecoration(labelText: 'Pin Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUserData,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }
}
