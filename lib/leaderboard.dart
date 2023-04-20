import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

class Leaderboard {
  Future<void> saveHighScore(String uid, int newScore) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final uid = currentUser.uid;
      // Get the previous score
      final scoreRef = FirebaseDatabase.instance.ref('leaderboard/$uid');
      final userScoreResult = await scoreRef.child('score').once();
      final score = (userScoreResult.snapshot.value as int?) ?? 0;

      // Return if it is not the high score
      if (newScore <= score) {
        return;
      }

      await scoreRef.set({
        'uid': uid,
        'score': newScore,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Iterable<LeaderboardModel>> getTopHighScores() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    // Retrieve first 20 data from highest to lowest in firebase
    final result = await FirebaseDatabase.instance
        .ref()
        .child('leaderboard')
        .orderByChild('score')
        .limitToLast(20)
        .once();

    final leaderboardScores = result.snapshot.children
        .map(
          (e) => LeaderboardModel.fromJson(e.value as Map, e.key == userId),
        )
        .toList();

    return leaderboardScores.reversed;
  }
}

class LeaderboardModel {
  final String uid;
  final int score;

  LeaderboardModel({
    required this.uid,
    required this.score,
  });

  factory LeaderboardModel.fromJson(Map json, bool isUser) {
    return LeaderboardModel(
      uid: isUser ? 'Toi' : json['uid'],
      score: json['score'],
    );
  }
}
