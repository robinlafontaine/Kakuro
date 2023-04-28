import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Couldn't Sign In!")));
    }
    return null;
  }

  Future<User> getUser() async {
    print(_auth.currentUser);
    return _auth.currentUser!;
  }

  Future<void> signOutGoogle() async {
    //TODO : Popup to show Sign Out
    await FirebaseAuth.instance.signOut();
    await _auth.signOut();
  }
}
