import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'firebase_options.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'auth.dart';
import 'leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pour avoir la base de données en local
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          //scaffoldBackgroundColor: config.colors.primaryBackground,
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
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
      backgroundColor: config.colors.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              config.images.logo,
              width: width(context) / 2,
              height: width(context) / 2,
            ),
            SizedBox(
              height: 70,
            ),
            boutton(
              value: "En ligne",
              onPress: () => {
                FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Auth(FirebaseAuth.instance).signInGoogle(context);
                  } else {
                    route(context, enligne());
                  }
                })
              },
            ),
            SizedBox(
              height: 20,
            ),
            boutton(
                value: "Hors ligne",
                onPress: () => {
                      //Auth(FirebaseAuth.instance).signInGoogle(context),
                      //log(FirebaseAuth.instance.app.name),
                      //route(context, game(Kakuro(10, 8, 7)))

                      route(context, horsligne())
                      //Leaderboard.saveHighScore(6000)
                    }),
          ],
        ),
      ),
    );
  }
}
