import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int?> getCounterValue(String userId, String counterId) async {
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('counters')
        .doc(counterId)
        .get();

    if (doc.exists && doc.data() != null) {
      return (doc.data() as Map<String, dynamic>)['value'] ?? 0;
    }
    return 0;
  }

  Future<void> updateCounter(String userId, String counterId, int newValue) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('counters')
        .doc(counterId)
        .set({'value': newValue}, SetOptions(merge: true));
  }

  Future<void> incrementCounter(String userId, String counterId) async {
    DocumentReference counterRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('counters')
        .doc(counterId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (snapshot.exists) {
        int newValue = ((snapshot.data() as Map<String, dynamic>)['value'] ?? 0) + 1;
        transaction.update(counterRef, {'value': newValue});
      }
    });
  }

  Future<void> decrementCounter(String userId, String counterId) async {
    DocumentReference counterRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('counters')
        .doc(counterId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (snapshot.exists) {
        int newValue = ((snapshot.data() as Map<String, dynamic>)['value'] ?? 0) - 1;
        transaction.update(counterRef, {'value': newValue});
      }
    });
  }
}
