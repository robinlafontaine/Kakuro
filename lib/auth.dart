import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakuro/screens/menu.dart';
import 'package:kakuro/config/config.dart';
import 'config/fonctions.dart';

class Auth {
  final FirebaseAuth _auth;

  Auth(this._auth);

  Future<UserCredential?> signInGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.profile');
        await _auth.signInWithPopup(googleProvider);

        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Echec de connection !")));
    }
    return null;
  }

  Future<bool> signedIn() async {
    return _auth.currentUser != null;
  }

  //check if signed in user is new or not
  Future<bool> isNewUser() async {
    return _auth.currentUser!.metadata.creationTime ==
        _auth.currentUser!.metadata.lastSignInTime;
  }

  void signOutGoogle(context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Config.online = false;
    route(context, const Menu());

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Déconnecté !")));
  }
}
