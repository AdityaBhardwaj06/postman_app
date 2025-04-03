import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreCounterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a Counter
  Future<void> createCounter(
    BuildContext context,
    String counterName,
    int initialValue,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final counterRef =
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('counters')
            .doc();

    await counterRef.set({
      'name': counterName,
      'value': initialValue,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    showSuccessSnackBar(context, "Counter created successfully!");
  }

  Future<int?> getCounterValue(String userId, String counterId) async {
    DocumentSnapshot doc =
        await _firestore
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

  // Get Stream of Counters
  Stream<QuerySnapshot> getUserCounters() {
    final user = _auth.currentUser;
    if (user == null) return Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('counters')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // Increment Counter
  Future<void> incrementCounter(
    BuildContext context,
    String userId,
    String counterId,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('counters')
        .doc(counterId)
        .update({
          'value': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
    showSuccessSnackBar(context, "Counter incremented!");
  }

  // Decrement Counter
  Future<void> decrementCounter(
    BuildContext context,
    String userId,
    String counterId,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('counters')
        .doc(counterId)
        .update({
          'value': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
    showSuccessSnackBar(context, "Counter decremented!");
  }

  // Update Counter to a Specific Value
  Future<void> updateCounter(
    BuildContext context,
    String userId,
    String counterId,
    int newValue,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('counters')
        .doc(counterId)
        .update({'value': newValue, 'updatedAt': FieldValue.serverTimestamp()});
    showSuccessSnackBar(context, "Counter updated!");
  }

  // Delete Counter
  Future<void> deleteCounter(
    BuildContext context,
    String userId,
    String counterId,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('counters')
        .doc(counterId)
        .delete();
    showSuccessSnackBar(context, "Counter deleted!");
  }

 
}

 // Snack bar to show success
  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Snack bar to show failure
  void showFailureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        duration: Duration(seconds: 1),
      ),
    );
  }