import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:login/dash_board_user/map.dart';
import 'package:login/dash_board_user/wastetype.dart';

class PaymentAndAddressScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedWasteTypes;

  const PaymentAndAddressScreen({
    required this.selectedWasteTypes,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentAndAddressScreenState createState() =>
      _PaymentAndAddressScreenState();
}

class _PaymentAndAddressScreenState extends State<PaymentAndAddressScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController mapController = TextEditingController();
  TextEditingController pickupDataController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proceed to Payment & Address'),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
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
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          addressController.text = userData['address'] ?? '';
          stateController.text = userData['state'] ?? '';
          pinCodeController.text = userData['pinCode'] ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.selectedWasteTypes.length,
                    itemBuilder: (ctx, index) {
                      final wasteType = widget.selectedWasteTypes[index];
                      return WasteTypeTile(
                        wasteType: wasteType,
                        onRemove: () {
                          setState(() {
                            widget.selectedWasteTypes.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Confirm Address',
                    style: Theme.of(context).textTheme.headline6,
                  ),
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
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            mapController.text = value; // Update map data
                          });
                        }
                      });
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Set Live Location'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: mapController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Map',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildCalendar(), // Add calendar widget
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle payment logic here
                      // After handling payment, update the user's data in Firestore
                      updateUserData();
                    },
                    child: const Text('Proceed to Payment'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          pickupDataController.text =
              selectedDay.toIso8601String(); // Update pickup data
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  void updateUserData() async {
    try {
      // Serialize the selectedWasteTypes data to Firestore-compatible format
      List<Map<String, dynamic>> serializedWasteTypes =
          widget.selectedWasteTypes.map((wasteType) {
        return wasteType.map((key, value) {
          if (value is IconData) {
            return MapEntry(key, value.codePoint);
          } else {
            return MapEntry(key, value);
          }
        });
      }).toList();

      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'address': addressController.text,
        'state': stateController.text,
        'pinCode': pinCodeController.text,
        'wasteTypes': serializedWasteTypes,
        'pickupData': pickupDataController.text,
        'map': mapController.text,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Navigate to payment screen after data is updated
      Navigator.pushReplacementNamed(context, '/payment_screen');
    } catch (error) {
      print('Error updating user data: $error');
      // Handle error
    }
  }
}
