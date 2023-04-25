import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// // Apple and Android
// database.settings = const Settings(persistenceEnabled: true);

// // Web
// await database.enablePersistence(const PersistenceSettings(synchronizeTabs: true));

class Leaderboard {
  static Future<List<QueryDocumentSnapshot>> getLeaderboard() async {
    try {
      final snapshot = await db
          .collection("leaderboard")
          .orderBy("score", descending: true)
          .limit(10)
          .get();
      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<void> saveHighScore(int newScore) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final uid = currentUser.uid;
      final docRef = db.collection("leaderboard").doc(uid);
      final docData = await docRef.get();
      final score = (docData.data()?["score"] as int?) ?? 0;

      if (newScore <= score) {
        return;
      }

      await docRef.set({"name": currentUser.displayName, "score": newScore},
          SetOptions(merge: true));
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> saveHighScoreTest(String uid, String name, int newScore) async {
    try {
      final docRef = db.collection("leaderboard").doc(uid);
      final docData = await docRef.get();
      final score = (docData.data()?["score"] as int?) ?? 0;

      if (newScore <= score) {
        return;
      }

      await docRef
          .set({"name": name, "score": newScore}, SetOptions(merge: true));
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
