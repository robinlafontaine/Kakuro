import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Duels {
  static Future getDuel(String gameID) async {
    try {
      final snapshot = await db.collection("duels").doc(gameID).get();

      return snapshot;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  static Future<List> getFinishedDuels(String uid) async {
    try {
      final snapshot = await db
          .collection("duelsEnded")
          .where("players", arrayContains: uid)
          .where("winner", isNotEqualTo: "")
          .get();

      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<List> getPendingDuels(String uid) async {
    try {
      final snapshot = await db
          .collection("duels")
          .where("players", arrayContains: uid)
          .where("winner", isEqualTo: "")
          .get();

      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<void> endDuel(String gameID, String winner, nBoard, mBoard) async {
    try {
      final size = "${nBoard}x$mBoard";
      await db.collection("duels").doc(gameID).get().then((value) {
        final players = value.data()!["players"];
        final timers = value.data()!["timers"];
        final difficulty = value.data()!["difficulty"];
        final result = db.collection("duelsEnded").doc(gameID);
        result.set({
          "winner": winner,
          "players": players,
          "board": size,
          "timers": timers,
          "difficulty": difficulty,
        });
        value.reference.delete();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteDuel(String gameID) async {
    try {
      await db.collection("duels").doc(gameID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
