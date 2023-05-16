import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'menu.dart';

class MesParties extends StatefulWidget {
  const MesParties({Key? key}) : super(key: key);
  @override
  State<MesParties> createState() => _MesPartiesState();
}

class _MesPartiesState extends State<MesParties> {
  List<String> grilles = [];
  List<String> chronos = [];
  List<String> minutes = [];
  List<String> secondes = [];
  List<String> etats = [];
  List etatSet = [];
  List<Kakuro> kakuros = [];

  List setEtat() {
    List liste = [];
    for (int k = 0; k < etats.length; k++) {
      liste.add(jsonDecode(etats[k]));
    }
    return liste;
  }

  List<String> paddedNumbers = List.generate(
    60,
    (index) => index.toString().padLeft(2, '0'),
  );

  String getAffichage(int n) {
    return paddedNumbers[n];
  }

  @override
  void initState() {
    super.initState();
    launch();
  }

  Future<void> launch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print("grilles: ${prefs.getStringList("grilles")}");
      print("chronos: ${prefs.getStringList("chronos")}");
      print("etats: ${prefs.getStringList("etats")}");
    }
    List<String>? mesgrilles = prefs.getStringList("grilles") ?? [];
    List<String>? meschronos = prefs.getStringList("chronos") ?? [];
    List<String>? mesetats = prefs.getStringList("etats") ?? [];
    grilles = mesgrilles;
    chronos = meschronos;
    etats = mesetats;
    setState(() {
      for (int i = 0; i < grilles.length; i++) {
        kakuros.add(Kakuro.withXML(grilles[i]));
        Duration duration = Duration(seconds: int.parse(chronos[i]));
        minutes.add(getAffichage(duration.inMinutes.remainder(60)));
        secondes.add(getAffichage(duration.inSeconds.remainder(60)));
      }
    });
    etatSet = setEtat();
  }

  Future<bool> go() async {
    return true;
  }

  void retour() {
    route(context, const Menu());
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
              child:
                  Appbar(home: false, enjeu: false, retour: () => {retour()}),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder<bool?>(
              future: go(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    if (grilles.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune partie en cours',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(2),
                      itemCount: grilles.length,
                      itemBuilder: (_, i) {
                        return Card(
                          elevation: 2,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SizedBox(
                            width: width(context) / 2,
                            height: height(context) *
                                0.12, // Change the height to 20% of the screen height
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Taille : ${kakuros[i].n}x${kakuros[i].m}",
                                          selectionColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          (kakuros[i].difficulte==4)?
                                          "Difficulté : Facile}"
                                          :(kakuros[i].difficulte==7)?
                                          "Difficulté : Moyen"
                                          :"Difficulté : Difficile",
                                          selectionColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Chrono : ${minutes[i]}:${secondes[i]}",
                                          selectionColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ],
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Config.newgame = false;
                                        route(
                                          context,
                                          Game(
                                            kakuro: kakuros[i],
                                            base: etatSet[i],
                                            index: i,
                                            chrono: int.parse(chronos[i]),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width(context) *
                                              0.05, // Change the horizontal padding to 20% of the screen width
                                        ),
                                        minimumSize: Size(
                                            width(context) * 0.05,
                                            height(context) *
                                                0.05), // Change the height to 40 pixels
                                      ),
                                      child: const Text(
                                        "REPRENDRE",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Aucune partie en cours',
                        style:
                            TextStyle(color: Config.colors.primaryTitreSelect),
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 2,
              reaload: () {
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
}
