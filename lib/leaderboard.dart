import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// await db
//     .enablePersistence(const PersistenceSettings(synchronizeTabs: true));

class Leaderboard {
  static Future getLeaderboard(int limite) async {
    // Récupère les 'documents' pour les n (limite) meilleurs scores
    try {
      final snapshot = await db
          .collection("leaderboard")
          .orderBy("score", descending: true)
          .limit(limite)
          .get();

      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future getPlayers() async {
    // Récupère les 'documents'
    try {
      final snapshot = await db.collection("leaderboard").get();

      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<void> saveHighScore(int newScore) async {
    // Sauvegarde le score de l'utilisateur dans la BDD
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

  static Future<void> addNewScore(int newPoints) async {
    // Sauvegarde le score de l'utilisateur dans la BDD
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final uid = currentUser.uid;
      final docRef = db.collection("leaderboard").doc(uid);
      final docData = await docRef.get();
      var score = (docData.data()?["score"] as int?) ?? 0;
      score += newPoints;

      await docRef.set({"name": currentUser.displayName, "score": score},
          SetOptions(merge: true));
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
