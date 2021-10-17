import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';

class FredericFeedbackSender {
  static Future<void> sendDeleteFeedback(String message, FredericUser user) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection('feedback').doc(user.uid);
    return doc.set({
      'email': user.email,
      'name': user.name,
      'delete_reason': message,
      'timestamp': Timestamp.now()
    });
  }
}
