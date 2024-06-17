import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                docs[index].data() as Map<String, dynamic>;
            return UserCard(data: data);
          },
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> data;

  UserCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(data['name'] ?? ''),
        subtitle: Text(data['email'] ?? ''),
        onTap: () {
          // Navigate to a detail view or edit screen
        },
      ),
    );
  }
}
