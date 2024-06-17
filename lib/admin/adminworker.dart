import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/admin/addworker.dart';
import 'package:login/admin/admincontroll.dart';

class WorkerPage extends StatefulWidget {
  @override
  _AdminWorkersPageState createState() => _AdminWorkersPageState();
}

class _AdminWorkersPageState extends State<WorkerPage> {
  final Workers _workers = Workers();

  List<Map<String, dynamic>> _workersList = [];

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  void _loadWorkers() async {
    List<Map<String, dynamic>> workers = await _workers.getWorkers();
    setState(() {
      _workersList = workers;
    });
  }

  void _addWorker(BuildContext context) async {
    // Navigate to the add worker form
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkerPage()),
    ).then((_) {
      // Refresh the list of workers when returning from the form
      _loadWorkers();
    });
  }

  void _showWorkerDetails(BuildContext context, Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(worker['name']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Email: ${worker['email']}'),
                Text('Phone Number: ${worker['phoneNumber']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
                Navigator.pop(context);
                _updateWorker(context, worker);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context);
                _deleteWorker(context, worker);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateWorker(BuildContext context, Map<String, dynamic> worker) {
    // Implement worker update logic here
  }

  void _deleteWorker(BuildContext context, Map<String, dynamic> worker) {
    // Implement worker delete logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Workers')),
      body: ListView.builder(
        itemCount: _workersList.length,
        itemBuilder: (context, index) {
          final worker = _workersList[index];
          return GestureDetector(
            onTap: () => _showWorkerDetails(context, worker),
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(worker['name']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addWorker(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
