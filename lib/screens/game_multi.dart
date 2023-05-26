import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kakuro/config/config.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:kakuro/duels.dart';

class GameMulti extends StatefulWidget {
  final Kakuro kakuro;
  final String ID;

  const GameMulti({super.key, required this.kakuro, required this.ID});

  @override
  State<GameMulti> createState() => GameMultiState(kakuro);
}

class GameMultiState extends State<GameMulti> with WidgetsBindingObserver {
  Kakuro kakuro;
  List grille = [];
  int seconde = 0;
  Timer? timer;
  int newIndex = 0;
  Duels duel = new Duels();
  Duration duration = const Duration();

  GameMultiState(this.kakuro);

  @override
  void initState() {
    super.initState();
    Config.multi.setMulti(true, widget.ID, kakuro.n, kakuro.m);
    WidgetsBinding.instance.addObserver(this);
    grille = kakuro.getBase();
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) &&
        Config.multi.inMulti == true) {
      // send current user data
      Duels().sendResults(
          Config.multi.gameID,
          FirebaseAuth.instance.currentUser?.uid,
          -1,
          Config.multi.n,
          Config.multi.m);
      Config.multi.clearMulti();
      if (kDebugMode) {
        print("multi cleared");
      }
      // TODO
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Multijoueur()))
          .then((value) {
        Navigator.pop(context);
      });
      setState(() {});
    }
  }

  void addPoints() {
    int puntos = (20 * (kakuro.n + kakuro.m + kakuro.difficulte) - seconde);
    Leaderboard.addNewScore(puntos);
  }

  String getEtat() {
    var s = json.encode(grille);
    return s;
  }

  bool testValide() {
    bool valide = true;
    for (int i = 0; i < kakuro.n; i++) {
      for (int j = 0; j < kakuro.m; j++) {
        if (grille[i][j] != kakuro.grilleUpdated[i][j]) {
          valide = false;
          // return valide;
        }
      }
    }
    if (!valide) {
      var copie = List.from(grille);
      // add a row and column of -1 at the beginning of the grid
      copie.insert(0, List.filled(kakuro.m, -1));
      valide = kakuro.estValideDiff(copie);
    }
    if (valide) {
      //addPoints();
      duel.sendResults(widget.ID, FirebaseAuth.instance.currentUser?.uid,
          seconde, kakuro.n, kakuro.m);
      Config.multi.clearMulti();
      route(context, const Multijoueur());
    }
    return valide;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    seconde += 1;
  }

  void maj(int i, int j, int valeur) {
    grille[i][j] = valeur;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        openDialogAbandon();
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, width(context) / 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Appbar(
                home: false,
                enjeu: true,
                retour: openDialogAbandon,
                abandon: openDialogAbandon,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height(context) / 10,
                  ),
                  Center(child: Scene(kakuro: kakuro, maj: maj)),
                  const SizedBox(
                    height: 30,
                  ),
                  // boutton to get a hint
                  ElevatedButton(
                    onPressed: () {
                      bool res = testValide();
                      if (!res) {
                        openDialogFaux();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Config.colors.primarySelect,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      padding: EdgeInsets.symmetric(
                        horizontal: width(context) *
                            0.20, // Change the horizontal padding to 20% of the screen width
                      ),
                      minimumSize: Size(
                          width(context) * 0.90,
                          height(context) *
                              0.08), // Change the height to 40 pixels
                    ),
                    child: Text(
                      "VALIDER",
                      selectionColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 2,
              checkGrille: () {},
              reaload: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Parametre())).then((value) {
                  Navigator.pop(context);
                });
              })),
    );
  }

  Future openDialogFaux() => showDialog(
      // met un message comme quoi la grille n'est pas valide
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Grille non valide'),
            content:
                const Text('La grille n\'est pas valide, veuillez réessayer'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Config.colors.defaultPrimary),
                  ))
            ],
          ));

  Future openDialogAbandon() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Abandon'),
            content: const Text(
                'Etes-vous sûr de vouloir abandonner cette partie ?'),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: [
              TextButton(
                  onPressed: () {
                    Config.multi.clearMulti();
                    duel.sendResults(
                        widget.ID,
                        FirebaseAuth.instance.currentUser?.uid,
                        -1,
                        kakuro.n,
                        kakuro.m);
                    route(context, const Multijoueur());
                    setState(() {});
                  },
                  child: Text(
                    "Oui",
                    style: TextStyle(color: Config.colors.defaultPrimary),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "NON",
                    style: TextStyle(color: Config.colors.defaultPrimary),
                  ))
            ],
          ));
}
