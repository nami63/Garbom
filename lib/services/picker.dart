import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<DocumentSnapshot> getUserData() {
    return _firestore.collection('users').doc(currentUser?.uid).get();
  }

  Future<void> updateUserData(
      List<Map<String, dynamic>> selectedWasteTypes,
      String address,
      String state,
      String pinCode,
      DateTime? pickUpDate,
      Position? currentPosition) {
    return _firestore.collection('users').doc(currentUser?.uid).update({
      'wasteTypes': selectedWasteTypes,
      'address': address,
      'state': state,
      'pinCode': pinCode,
      'pickUpDate': pickUpDate?.toIso8601String(),
      'currentLocation': currentPosition != null
          ? {
              'latitude': currentPosition.latitude,
              'longitude': currentPosition.longitude,
            }
          : null,
    });
  }

  Stream<QuerySnapshot> getPickupRequests() {
    return _firestore
        .collection('users')
        .where('wasteTypes', isNotEqualTo: []).snapshots();
  }
}
