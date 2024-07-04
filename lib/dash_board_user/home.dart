import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/dash_board_user/map.dart';
import 'package:login/dash_board_user/profile.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garbage Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            GarbageCard(title: 'Plastic Waste', icon: Icons.delete),
            GarbageCard(title: 'Organic Waste', icon: Icons.nature),
            GarbageCard(title: 'Electronic Waste', icon: Icons.devices),
          ],
        ),
      ),
    );
  }
}

class GarbageCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const GarbageCard({
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentAndAddressScreen(title: title),
            ),
          );
        },
      ),
    );
  }
}

class PaymentAndAddressScreen extends StatefulWidget {
  final String title;

  const PaymentAndAddressScreen({required this.title, super.key});

  @override
  _PaymentAndAddressScreenState createState() =>
      _PaymentAndAddressScreenState();
}

class _PaymentAndAddressScreenState extends State<PaymentAndAddressScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - Payment & Address'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No address found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          addressController.text = userData['address'] ?? '';
          stateController.text = userData['state'] ?? '';
          pinCodeController.text = userData['pinCode'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm Address for ${widget.title}',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 16.0),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: stateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'State',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: pinCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pin Code',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Set Live Location'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle payment logic here
                  },
                  child: const Text('Proceed to Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
