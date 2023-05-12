import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
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

  Future<bool> launch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? mesgrilles = prefs.getStringList("grilles") ?? [];
    List<String>? meschronos = prefs.getStringList("chronos") ?? [];
    List<String>? mesetats = prefs.getStringList("etats") ?? [];
    grilles = mesgrilles;
    chronos = meschronos;
    etats = mesetats;
    setState(() {
      for (int i = 0; i < mesgrilles.length; i++) {
        kakuros.add(Kakuro.withXML(grilles[i]));
        Duration duration = Duration(seconds: int.parse(chronos[i]));
        minutes.add(getAffichage(duration.inMinutes.remainder(60)));
        secondes.add(getAffichage(duration.inSeconds.remainder(60)));
      }
    });
    etatSet = setEtat();
    return grilles.isNotEmpty;
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
                                    color: Config.colors.primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
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
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Config.colors
                                              .primaryBackground, // background
                                          foregroundColor: Config.colors
                                              .primaryTextBlack, // foreground
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          minimumSize: const Size(150, 50),
                                        ),
                                        onPressed: () {
                                          Config.newgame = false;
                                          route(
                                              context,
                                              Game(
                                                  kakuro: kakuros[i],
                                                  base: etatSet[i],
                                                  index: i,
                                                  chrono:
                                                      int.parse(chronos[i])));
                                        },
                                        child: const Text("JOUER"))
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
