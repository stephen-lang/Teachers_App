// lib/core/activity/activity_logger.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityLogger {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> log({
    required String action,
    String? details,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.collection('activityLogs').add({
      'userId': user.uid,
      'action': action,
      'details': details ?? '',
      'timestamp': Timestamp.now(),
    });
  }
}
