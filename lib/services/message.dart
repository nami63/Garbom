import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// SMTP server configuration (Gmail example)
final smtpServer = gmail('namithakv63@gmail.com', 'your_password');

// Function to send email notification
Future<void> sendEmailNotification(String recipientEmail) async {
  final message = Message()
    ..from = Address('namithakv63@gmail.com', 'Your Name')
    ..recipients.add(recipientEmail) // Recipient's email address from Firestore
    ..subject = 'Task Completed'
    ..text = 'Your task has been completed.';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}

void markTaskAsCompleted(String userUid) {
  // Example: Fetch user document from Firestore
  FirebaseFirestore.instance
      .collection('users')
      .doc(userUid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      String recipientEmail = documentSnapshot.data()['email'];
      sendEmailNotification(recipientEmail);
    } else {
      print('Document does not exist on the database');
    }
  }).catchError((error) {
    print('Error getting document: $error');
  });
}
