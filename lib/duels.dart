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

  static Future<Object> getFinishedDuels(String uid) async {
    try {
      final snapshot = await db
          .collection("duelsEnded")
          .where("players", arrayContains: uid)
          .where("winner", isNotEqualTo: "")
          .get();

      return snapshot;
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

      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs;
      }
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

  Future<bool> checkuid(String uid) async {
    try {
      final snapshot = await db.collection("leaderboard").doc(uid).get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future startDuel(uid1, uid2, diff, xmlKakuro) async {
    try {
      await db.collection("duels").add({
        'board': xmlKakuro,
        'difficulty': diff,
        'done': {uid1: false, uid2: false},
        'players': [uid1, uid2],
        'timers': {uid1: 0, uid2: 0},
        'winner': ""
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future sendResults(idpartie, uid, chrono, kakuroN, kakuroM) async {
    try {
      // send the value of chrono to the database
      await db.collection("duels").doc(idpartie).update({
        'timers': {uid: chrono},
        'done': {uid: true}
      });
      final snapshot = await db.collection("duels").doc(idpartie).get();
      // if all values in done dictionnary are true, the game is over
      if (snapshot.data()!["done"][snapshot.data()!["players"][0]] &&
          snapshot.data()!["done"][snapshot.data()!["players"][1]]) {
        // if the game is over, we check who won
        final player1 = snapshot.data()!["players"][0];
        final player2 = snapshot.data()!["players"][1];
        final timer1 = snapshot.data()!["timers"][player1];
        final timer2 = snapshot.data()!["timers"][player2];
        if (timer1 < timer2) {
          await endDuel(idpartie, player1, kakuroN, kakuroM);
        } else if (timer1 > timer2) {
          await endDuel(idpartie, player2, kakuroN, kakuroM);
        } else {
          await endDuel(idpartie, "draw", kakuroN, kakuroM);
        }
        // delete the game from the database
        await deleteDuel(idpartie);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
