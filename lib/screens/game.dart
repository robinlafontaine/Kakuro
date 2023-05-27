import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakuro/config/config.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/bouttonmd3.dart';
import 'package:kakuro/widgets/navbar.dart';
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
  int newIndex = 0;
  Duration duration = const Duration();
  int indices = 1;

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
    int puntos =
        (30 * (kakuro.n * kakuro.m * kakuro.difficulte) - seconde) ~/ indices;
    Leaderboard.addNewScore(puntos);
  }

  String getEtat() {
    var s = json.encode(grille);
    return s;
  }

  void saveGrille() async {
    List? grilles = GetStorage().read("grilles");
    List? chronos = GetStorage().read("chronos");
    List? etats = GetStorage().read("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.add(kakuro.toXML());
    chronos.add(seconde.toString());
    String etatsActuel = getEtat();
    etats.add(etatsActuel);
    newIndex = grilles.length - 1;
    print(grilles.length - 1);
    GetStorage().write("grilles", grilles);
    GetStorage().write("chronos", chronos);
    GetStorage().write("etats", etats);

    /*  await prefs.setStringList('grilles', []);
    await prefs.setStringList('chronos', []);
    await prefs.setStringList('etats', []);*/
  }

  void saveGrilleAndReload() async {
    List? grilles = GetStorage().read("grilles");
    List? chronos = GetStorage().read("chronos");
    List? etats = GetStorage().read("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.add(kakuro.toXML());
    chronos.add(seconde.toString());
    String etatsActuel = getEtat();
    etats.add(etatsActuel);
    newIndex = grilles.length - 1;
    print(grilles.length - 1);

    GetStorage().write("grilles", grilles);
    GetStorage().write("chronos", chronos);
    GetStorage().write("etats", etats);

    route(
        context,
        Game(
          kakuro: kakuro,
          base: grille,
          index: newIndex,
          chrono: seconde,
        ));
  }

  void majGrille() async {
    List? etats = GetStorage().read("etats");
    List? chronos = GetStorage().read("chronos");
    etats ??= [];
    chronos ??= [];
    String etatsActuel = getEtat();
    String chronoActuel = seconde.toString();
    etats[widget.index!] = etatsActuel;
    chronos[widget.index!] = chronoActuel;

    GetStorage().write("etats", etats);
    GetStorage().write("chronos", chronos);
  }

  Future<void> suppGrille() async {
    List? grilles = GetStorage().read("grilles");
    List? chronos = GetStorage().read("chronos");
    List? etats = GetStorage().read("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.remove(grilles[widget.index!]);
    chronos.remove(chronos[widget.index!]);
    etats.remove(etats[widget.index!]);

    GetStorage().write("grilles", grilles);
    GetStorage().write("chronos", chronos);
    GetStorage().write("etats", etats);
  }

  bool testValide({indice = false}) {
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
    if (indice) {
      return valide;
    }
    if (valide) {
      addPoints();
      openDialogVictoire();
      return valide;
    }
    AudioPlayer().play(AssetSource("roblox.mp3"));
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
      route(context, const Menu());
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
          backgroundColor: Theme.of(context).colorScheme.background,
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
                  // boutton to get a hint
                  BouttonMd3(
                      onTap: () {
                        openDialogIndice();
                      },
                      text: "INDICE"),
                  const SizedBox(
                    height: 20,
                  ),
                  BouttonMd3(
                      onTap: () {
                        bool res = testValide();
                        if (!res) {
                          openDialogFaux();
                        }
                      },
                      text: "VERIFIER"),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 2,
              checkGrille: () {
                (Config.newgame) ? saveGrille() : majGrille();
              },
              reaload: () {
                saveGrille();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Parametre(),
                      transitionDuration: const Duration(seconds: 0),
                    )).then((value) {
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
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
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
                    if (Config.newgame == true) {
                      route(context, const NouvellePartie());
                    } else {
                      suppGrille()
                          .then((value) => route(context, const MesParties()));
                    }
                    setState(() {});
                  },
                  child: Text(
                    "Oui",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Non",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ))
            ],
          ));

  Future openDialogVictoire() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Victoire'),
            content: const Text('Félicitation, vous avez gagné !'),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (Config.newgame == false) suppGrille();
                    route(context, const Menu());
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ))
            ],
          ));

  // show a dialog to say that the player has asked for a hint
  // then find a random value to give to the playerv and update the grid with the value
  Future openDialogIndice() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Indice'),
            content: const Text('Voulez-vous un indice ?'),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: [
              TextButton(
                  onPressed: () {
                    indices++;
                    if (kDebugMode) print(indices);
                    int i = Random().nextInt(kakuro.n - 1);
                    int j = Random().nextInt(kakuro.m - 1);
                    var zero = false;
                    for (var i = 0; i < kakuro.n; i++) {
                      for (var j = 0; j < kakuro.m; j++) {
                        if (grille[i][j] == 0) {
                          zero = true;
                        }
                      }
                    }
                    if (!zero) {
                      if (!testValide(indice: true)) {
                        while (kakuro.grilleUpdated[i][j] == grille[i][j]) {
                          i = Random().nextInt(kakuro.n - 1) + 1;
                          j = Random().nextInt(kakuro.m - 1) + 1;
                        }

                        grille[i][j] = kakuro.grilleUpdated[i][j];
                        Navigator.pop(context);
                        // popup avec la valeur changee et la position
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Indice'),
                                  content: Text(
                                      'La valeur en position (${i + 1}, ${j + 1}) doit être changée par ${kakuro.grilleUpdated[i][j]}'),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (Config.newgame) {
                                            Config.newgame = false;
                                            saveGrilleAndReload();
                                          } else {
                                            route(
                                                context,
                                                Game(
                                                  kakuro: kakuro,
                                                  base: grille,
                                                  index: widget.index,
                                                  chrono: seconde,
                                                ));
                                          }
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                        ))
                                  ],
                                ));
                      } else {
                        Navigator.pop(context);
                        // popup disant que la grille est valide
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Indice'),
                                  content: const Text(
                                      'La grille est valide, vous n\'avez pas besoin d\'indice'),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                        ))
                                  ],
                                ));
                        return;
                      }
                    } else {
                      while (grille[i][j] != 0) {
                        i = Random().nextInt(kakuro.n - 1) + 1;
                        j = Random().nextInt(kakuro.m - 1) + 1;
                      }
                      grille[i][j] = kakuro.grilleUpdated[i][j];

                      // popup avec la valeur changee et la position
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Indice'),
                                content: Text(
                                    'La valeur en position (${i + 1}, ${j + 1}) est ${kakuro.grilleUpdated[i][j]}'),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (Config.newgame) {
                                          Config.newgame = false;
                                          saveGrilleAndReload();
                                        } else {
                                          route(
                                              context,
                                              Game(
                                                kakuro: kakuro,
                                                base: grille,
                                                index: widget.index,
                                                chrono: seconde,
                                              ));
                                        }
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ))
                                ],
                              ));
                    }
                    // show the number in the grid
                    setState(() {
                      grille[i][j] = kakuro.grilleUpdated[i][j];
                    });
                  },
                  child: Text(
                    "Oui",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "NON",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ))
            ],
          ));
}
