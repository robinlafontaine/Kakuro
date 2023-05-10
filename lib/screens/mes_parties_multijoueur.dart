import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/duels.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'menu.dart';

class MesPartiesMultijoueur extends StatefulWidget {
  const MesPartiesMultijoueur({super.key});

  @override
  State<MesPartiesMultijoueur> createState() => MesPartiesState();
}

class MesPartiesState extends State<MesPartiesMultijoueur> {
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

  String getAffichage(int n) {
    return n.toString().padLeft(2, "0");
  }

  Future<bool> launch() async {
    // Future<List> duelsEnCours =
    // Duels.getPendingDuels(FirebaseAuth.instance.currentUser!.uid);
    if (kDebugMode) {
      //print("duelsEnCours: $duelsEnCours");
    }
    // for (var doc in duelsEnCours) {
    //   if (doc.data()["etat"] == "attente") {
    //     route(context, multijoueur());
    //     return false;
    //   }
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? grilles = prefs.getStringList("grilles");
    List<String>? chronos = prefs.getStringList("chronos");
    List<String>? etats = prefs.getStringList("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    setState(() {
      grilles = grilles!;
      chronos = chronos!;
      etats = etats!;
      for (int i = 0; i < grilles!.length; i++) {
        kakuros.add(Kakuro.withXML(grilles![i]));
        Duration duration = Duration(seconds: int.parse(chronos![i]));
        minutes.add(getAffichage(duration.inMinutes.remainder(60)));
        secondes.add(getAffichage(duration.inSeconds.remainder(60)));
      }
      etatSet = setEtat();
    });
    return grilles!.isNotEmpty;
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
          backgroundColor: Config.colors.primaryBackground,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, width(context) / 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Appbar(home: false, enjeu: false, retour: () => {retour()}),
            ),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder<bool>(
                future: launch(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(2),
                            itemCount: grilles.length,
                            itemBuilder: (_, i) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Config.colors.primaryColor),
                                width: width(context) / 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                            "Taille : (${kakuros[i].n},${kakuros[i].m})",
                                            style: TextStyle(
                                                color: Config
                                                    .colors.primaryTextColor)),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "Difficulté : ${kakuros[i].difficulte}",
                                            style: TextStyle(
                                                color: Config
                                                    .colors.primaryTextColor)),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "Chrono : ${minutes[i]}:${secondes[i]}",
                                            style: TextStyle(
                                                color: Config
                                                    .colors.primaryTextColor)),
                                      ],
                                    ),
                                    Boutton(
                                        value: "JOUER",
                                        couleur: true,
                                        size: width(context) / 3,
                                        onPress: () {
                                          Config.newgame = false;
                                          route(
                                              context,
                                              Game(
                                                  kakuro: kakuros[i],
                                                  base: etatSet[i],
                                                  index: i,
                                                  chrono:
                                                      int.parse(chronos[i])));
                                        })
                                  ],
                                ),
                              );
                            }),
                      ));
                    } else {
                      return Center(
                          child: Text(
                        'Aucune partie en cours',
                        style:
                            TextStyle(color: Config.colors.primaryTitreSelect),
                      ));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          bottomNavigationBar: Navbar(
              actif: 2,
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
}
