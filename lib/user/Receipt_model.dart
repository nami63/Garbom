import 'package:cloud_firestore/cloud_firestore.dart';

class Receipt {
  final String userName;
  final List<String> wasteTypes;
  final double amountPaid;
  final String paymentMode;
  final DateTime dateTime;

  Receipt({
    required this.userName,
    required this.wasteTypes,
    required this.amountPaid,
    required this.paymentMode,
    required this.dateTime,
  });
}
