import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/dash_board_user/Paymentpage.dart';
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
  TextEditingController kgController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        addressController.text = userData['address'] ?? '';
        stateController.text = userData['state'] ?? '';
        pinCodeController.text = userData['pinCode'] ?? '';
        mapController.text = userData['map'] ?? '';
        pickupDataController.text = userData['pickupData'] ?? '';
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var wasteType in widget.selectedWasteTypes) {
      total += wasteType['amount'] ?? 0.0;
    }
    return total;
  }

  double _calculateTotalTax(double totalAmount) {
    // Assuming 18% tax
    return totalAmount * 0.18;
  }

  double _calculateFinalAmount(double totalAmount, double totalTax) {
    return totalAmount + totalTax;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = _calculateTotalAmount();
    double totalTax = _calculateTotalTax(totalAmount);
    double finalAmount = _calculateFinalAmount(totalAmount, totalTax);

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
                  Center(
                    child: Text(
                      'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Total Tax: ₹${totalTax.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Final Amount: ₹${finalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
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
                        MaterialPageRoute(builder: (context) => LocationPage()),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            LatLng location = value as LatLng;
                            mapController.text =
                                '${location.latitude}, ${location.longitude}';
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
                  Center(
                    child: TextField(
                      controller: kgController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter total kg',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String kgText = kgController.text.trim();
                        if (kgText.isNotEmpty) {
                          double kg = double.tryParse(kgText) ?? 0.0;
                          finalAmount *=
                              kg; // Adjust finalAmount based on kg input
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Total Amount'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Total Amount: ₹${finalAmount.toStringAsFixed(2)}'),
                                    Text(
                                        'Total Tax: ₹${totalTax.toStringAsFixed(2)}'),
                                    Text(
                                        'Final Amount: ₹${_calculateFinalAmount(finalAmount, totalTax).toStringAsFixed(2)}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Please enter a valid value for Kg.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text('Calculate Total'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await updateUserData();
                        // Proceed to PaymentPage to choose payment method
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentPage(finalAmount: finalAmount),
                          ),
                        );
                      },
                      child: const Text('Proceed to Payment'),
                    ),
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

  Future<void> updateUserData() async {
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
        'session': false, // Initially set to false
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('User data updated successfully');
    } catch (error) {
      print('Error updating user data: $error');
      // Handle error
    }
  }
}

class WasteTypeTile extends StatelessWidget {
  final Map<String, dynamic> wasteType;
  final VoidCallback onRemove;

  const WasteTypeTile({
    required this.wasteType,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wasteType['name'] ?? ''),
      subtitle:
          Text('Amount: ₹${wasteType['amount']?.toStringAsFixed(2) ?? ''}'),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle),
        onPressed: onRemove,
      ),
    );
  }
}
