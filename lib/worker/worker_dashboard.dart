import 'package:flutter/material.dart';
import 'package:login/worker/workerHome.dart';
import 'package:login/worker/worker_login.dart'; // Ensure this is the correct import for WorkerLog
import 'package:login/worker/worker_history.dart'; // Corrected import
import 'package:login/worker/worker_earnings.dart'; // Corrected import

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({Key? key})
      : super(key: key); // Fixed constructor syntax

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    WorkerHomePage(),
    HistoryPage(),
    TaskCountPage(),
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkerLog()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        toolbarHeight: 50,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          if (newIndex == 3) {
            _showLogoutDialog(context); // Show logout confirmation dialog
          } else {
            setState(() {
              _currentIndex = newIndex;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: 'Earnings',
            icon: Icon(Icons.currency_rupee),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(Icons.logout),
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 221, 57, 186),
        unselectedItemColor: Color.fromARGB(255, 87, 84, 238),
      ),
    );
  }
}
