import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// await db
//     .enablePersistence(const PersistenceSettings(synchronizeTabs: true));

class Leaderboard {
  static Future<Object> getLeaderboard() async {
    // Récupère les 'documents' pour les n (limite) meilleurs scores
    try {
      final snapshot = await db
          .collection("leaderboard")
          .orderBy("score", descending: true)
          .get();
      return snapshot;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<Object> getPlayers() async {
    // Récupère les 'documents'
    try {
      final snapshot = await db.collection("leaderboard").get();

      return snapshot;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<String> getPlayerName(String uid) async {
    final snapshot = await db.collection("leaderboard").doc(uid).get();
    return snapshot.data()!["name"];
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
      if (newPoints > score) {
        score = newPoints;
        await docRef.set({"name": currentUser.displayName, "score": score},
            SetOptions(merge: true));
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> userExists(context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await db.collection("leaderboard").doc(uid).set(
        {"name": FirebaseAuth.instance.currentUser?.displayName},
        SetOptions(merge: true));
  }
}
