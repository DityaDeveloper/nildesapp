import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/quiz_model.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<QuizModel>> getQuizEnglish() {
    return _db
        .collection('quizenglish')
        // .where('type', isEqualTo: 'admin')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => QuizModel.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }
  Stream<List<QuizModel>> getQuizIndonesia() {
    return _db
        .collection('quiz')
        // .where('type', isEqualTo: 'admin')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => QuizModel.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }
}
