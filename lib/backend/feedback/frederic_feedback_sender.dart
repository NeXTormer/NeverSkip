import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';

class FredericFeedbackSender {
  static Future<void> sendDeleteFeedback(String message,
      List<String?> deleteReasonChoices, FredericUser user) async {
    if (message == 'integrationtest') return;
    if (message == 'test') return;

    DocumentReference doc =
        FirebaseFirestore.instance.collection('delete_feedback').doc(user.id);
    return doc.set({
      'timestamp': Timestamp.now(),
      'email': user.email,
      'name': user.name,
      'delete_reason': message,
      'delete_reason_choices': deleteReasonChoices,
    });
  }

  static Future<void> sendInAppFeedback(
      FredericUser user, FredericFeedbackRating rating, String text) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('feedback');
    return collectionReference.add({
      'timestamp': Timestamp.now(),
      'email': user.email,
      'name': user.name,
      'uid': user.id,
      'rating': _getRating(rating),
      'text': text
    });
  }

  static String _getRating(FredericFeedbackRating rating) {
    switch (rating) {
      case FredericFeedbackRating.Happy:
        return 'Happy';
      case FredericFeedbackRating.Neutral:
        return 'Neutral';
      case FredericFeedbackRating.Unhappy:
        return 'Unhappy';
    }
  }
}

enum FredericFeedbackRating { Happy, Unhappy, Neutral }
