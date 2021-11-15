import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';

class FredericFeedbackSender {
  static Future<void> sendDeleteFeedback(
      String message, List<String?> deleteReasonChoices, FredericUser user) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection('feedback').doc(user.uid);
    return doc.set({
      'email': user.email,
      'name': user.name,
      'delete_reason': message,
      'delete_reason_choices': deleteReasonChoices,
      'timestamp': Timestamp.now()
    });
  }
}
