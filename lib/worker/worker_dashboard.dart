import 'package:flutter/material.dart';
import 'package:login/worker/workerHome.dart';
import 'package:login/worker/worker_login.dart';

// ignore: camel_case_types
class workerdash extends StatefulWidget {
  const workerdash({super.key});

  @override
  State<workerdash> createState() => _workerdashState();
}

// ignore: camel_case_types
class _workerdashState extends State<workerdash> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    WorkerHomePage(),
    const Customer(),
    const Loc(),
    const Price(),
    const log(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GarboManage"),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        toolbarHeight: 50,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Customers',
            icon: Icon(Icons.tv_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Location',
            icon: Icon(Icons.inventory_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Price',
            icon: Icon(Icons.money),
          ),
          BottomNavigationBarItem(
            label: 'logout',
            icon: Icon(Icons.person),
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 107, 100, 237),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Define the different pages
// ignore: camel_case_types

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('About Us Page'));
  }
}

class Loc extends StatelessWidget {
  const Loc({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Coming Soon Page'));
  }
}

class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Price Page'));
  }
}

// ignore: camel_case_types
class log extends StatelessWidget {
  const log({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkerLog()),
          );
        },
        child: const Text('Logout'),
      ),
    );
  }
}
