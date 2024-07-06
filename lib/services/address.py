import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserAddress(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
