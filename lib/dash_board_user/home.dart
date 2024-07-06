import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:login/dash_board_user/Payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserHome(),
    );
  }
}

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final List<Map<String, dynamic>> wasteTypes = [
    {'name': 'Organic', 'icon': Icons.eco, 'amount': '5 /-'},
    {'name': 'Plastic', 'icon': Icons.local_drink, 'amount': '8 /-'},
    {'name': 'Paper', 'icon': Icons.description, 'amount': '5 /-'},
    {'name': 'Metal', 'icon': Icons.build, 'amount': '20 /-'},
    {'name': 'Glass', 'icon': Icons.wine_bar, 'amount': '30 /-'},
    {'name': 'E-waste', 'icon': Icons.devices, 'amount': '40 /-'},
  ];

  final List<Map<String, dynamic>> selectedWasteTypes = [];

  void _navigateToPaymentAndAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PaymentAndAddressScreen(selectedWasteTypes: selectedWasteTypes)),
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedWasteTypes.clear();
          selectedWasteTypes.addAll(value);
        });
      }
    });
  }

  void _addToSelected(Map<String, dynamic> wasteType) {
    setState(() {
      selectedWasteTypes.add(wasteType);
    });
    _navigateToPaymentAndAddress(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color:
                  const Color.fromARGB(255, 159, 154, 252), // Light blue color
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            // Add your onPressed code here!
                            print('Location button pressed');
                          },
                        ),
                        const Text(
                          'Hello Name',
                          style: TextStyle(
                            fontSize: 28, // Increased font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder for symmetry
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Effective management of garbage is crucial for a sustainable environment. Let’s work together to keep our surroundings clean and green.',
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontFamily:
                                'Bradley Hand ITC', // Changed font family
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 1,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(
                    255, 184, 181, 247), // Grey background color
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: wasteTypes.length,
                    itemBuilder: (ctx, index) {
                      return WasteTypeCard(
                        name: wasteTypes[index]['name'],
                        icon: wasteTypes[index]['icon'],
                        amount: wasteTypes[index]['amount'],
                        onTap: () => _addToSelected(wasteTypes[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPaymentAndAddress(context),
        child: const Icon(Icons.payment),
      ),
    );
  }
}

class WasteTypeCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String amount;
  final VoidCallback onTap;

  const WasteTypeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: const Color.fromARGB(
                      255, 107, 100, 237), // Changed icon color to blue
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Amount: $amount',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
