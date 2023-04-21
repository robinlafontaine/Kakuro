import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'firebase_options.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'auth.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'GeeskforGeeks';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(config.images.logo,
              width: width(context)/2,
              height: width(context)/2,
            ),
            SizedBox(
              height: 70,
            ),
            boutton(
                value: "En ligne",
                onPress: () => {
                  Auth(FirebaseAuth.instance).signInGoogle(context)}
            ),
            SizedBox(
              height: 20,
            ),
            boutton(
                value: "Hors ligne",
                onPress: () => {
                  //Auth(FirebaseAuth.instance).signInGoogle(context),
                  //log(FirebaseAuth.instance.app.name),
                  route(context, game(Kakuro(6, 6, 6)))
                }
            ),
          ],
        ),
      ),
    );
  }
}
