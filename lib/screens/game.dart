import 'dart:async';
import 'dart:convert';
import 'package:kakuro/Config/Config.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/Boutton.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';
import 'mes_parties.dart';

class Game extends StatefulWidget {
  final Kakuro kakuro;
  final List? base;
  final int? index;
  final int? chrono;

  const Game(
      {super.key, required this.kakuro, this.base, this.index, this.chrono});

  @override
  State<Game> createState() => GameState(kakuro);
}

class GameState extends State<Game> {
  Kakuro kakuro;
  List grille = [];
  int seconde = 0;
  Timer? timer;
  Duration duration = const Duration();

  GameState(this.kakuro);

  @override
  void initState() {
    super.initState();
    if (widget.base == null && widget.chrono == null) {
      grille = kakuro.getBase();
    } else {
      seconde = widget.chrono!;
      grille = widget.base!;
    }
    startTimer();
  }

  void addPoints() {
    int puntos = (20 * (kakuro.n + kakuro.m + kakuro.difficulte) - seconde);
    Leaderboard.addNewScore(puntos);
  }

  String getEtat() {
    var s = json.encode(grille);
    return s;
  }

  Future<void> saveGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? grilles = prefs.getStringList("grilles");
    List<String>? chronos = prefs.getStringList("chronos");
    List<String>? etats = prefs.getStringList("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.add(kakuro.toXML());
    chronos.add(seconde.toString());
    String etatsActuel = getEtat();
    etats.add(etatsActuel);
    await prefs.setStringList('grilles', grilles);
    await prefs.setStringList('chronos', chronos);
    await prefs.setStringList('etats', etats);

    /*  await prefs.setStringList('grilles', []);
    await prefs.setStringList('chronos', []);
    await prefs.setStringList('etats', []);*/
  }

  Future<void> majGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? etats = prefs.getStringList("etats");
    List<String>? chronos = prefs.getStringList("chronos");
    etats ??= [];
    chronos ??= [];
    String etatsActuel = getEtat();
    String chronoActuel = seconde.toString();
    etats[widget.index!] = etatsActuel;
    chronos[widget.index!] = chronoActuel;
    await prefs.setStringList('etats', etats);
    await prefs.setStringList('chronos', chronos);
  }

  Future<void> suppGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? grilles = prefs.getStringList("grilles");
    List<String>? chronos = prefs.getStringList("chronos");
    List<String>? etats = prefs.getStringList("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.remove(grilles[widget.index!]);
    chronos.remove(chronos[widget.index!]);
    etats.remove(etats[widget.index!]);
    await prefs.setStringList('grilles', grilles);
    await prefs.setStringList('chronos', chronos);
    await prefs.setStringList('etats', etats);
  }

  bool testValide() {
    bool valide = true;
    for (int i = 0; i < kakuro.n; i++) {
      for (int j = 0; j < kakuro.m; j++) {
        if (grille[i][j] != kakuro.grilleUpdated[i][j]) {
          valide = false;
          return valide;
        }
      }
    }
    if (valide) {
      addPoints();
      if (Config.newgame == false) suppGrille();
      route(context, const Menu());
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

  void retour() {
    if (Config.newgame) {
      saveGrille();
      route(context, const NouvellePartie());
    } else {
      majGrille();
      route(context, const MesParties());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        retour();
        return true;
      },
      child: Scaffold(
          backgroundColor: Config.colors.primaryBackground,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, width(context) / 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Appbar(
                home: false,
                enjeu: true,
                retour: retour,
                chrono: widget.chrono,
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
                  Center(
                      child: (widget.base == null)
                          ? Scene(kakuro: kakuro, maj: maj)
                          : Scene(kakuro: kakuro, maj: maj, base: widget.base)),
                  const SizedBox(
                    height: 30,
                  ),
                  Boutton(
                      value: "VALIDER",
                      onPress: () {
                        bool res = testValide();
                        if (!res) {
                          openDialogFaux();
                        }
                      }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 10,
              checkGrille: () {
                (Config.newgame) ? saveGrille() : majGrille();
              },
              reaload: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Parametre())).then((value) {
                  setState(() {});
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
            actions: [
              TextButton(
                  onPressed: () {
                    if (Config.newgame == true) {
                      route(context, const NouvellePartie());
                    } else {
                      suppGrille()
                          .then((value) => route(context, const MesParties()));
                    }
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
