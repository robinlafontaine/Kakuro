import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/gameMulti.dart';
import 'package:kakuro/screens/parametres.dart';

import '../duels.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'menu.dart';

class MesPartiesMultijoueur extends StatefulWidget {
  const MesPartiesMultijoueur({super.key});

  @override
  State<MesPartiesMultijoueur> createState() => MesPartiesState();
}

final _uid = FirebaseAuth.instance.currentUser!.uid;

class MesPartiesState extends State<MesPartiesMultijoueur> {
  List<String> grilles = [];
  List<Kakuro> kakuros = [];
  List<String> adversaires = [];
  Map<String, String> grillesAndID = {};

  Future<bool> go() async {
    return true;
  }

  String getAffichage(int n) {
    return n.toString().padLeft(2, "0");
  }

  @override
  void initState() {
    super.initState();
    launch();
  }

  Future<void> launch() async {
    List duelsEnCours = await Duels.getPendingDuels(_uid);

    for (var doc in duelsEnCours) {
      grilles.add(doc['board']);
      // map the id of the game to the board
      grillesAndID[doc['board']] = doc.id;
      var adversaire =
          doc['players'][0] == _uid ? doc['players'][1] : doc['players'][0];
      adversaires.add(await Leaderboard.getPlayerName(adversaire));
    }

    setState(() {
      for (int i = 0; i < grilles.length; i++) {
        kakuros.add(Kakuro.withXML(grilles[i]));
      }
    });
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
          body: SingleChildScrollView(
            child: FutureBuilder<bool>(
                future: go(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      if (grilles.isEmpty) {
                        return Center(
                          child: Text(
                            'Aucune invitation',
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
                            color: Theme.of(context).colorScheme.primary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              width: width(context) / 2,
                              height: height(context) *
                                  0.12, // Change the height to 20% of the screen height
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            adversaires[i],
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "Taille : ${kakuros[i].n}x${kakuros[i].m}",
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "Difficulté : ${kakuros[i].difficulte}",
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                        ],
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Config.newgame = false;
                                          route(
                                            context,
                                            GameMulti(
                                              kakuro: kakuros[i],
                                              ID: grillesAndID[grilles[i]]!,
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
                                          "COMMENCER",
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
                          'Aucune invitation',
                          style: TextStyle(
                              color: Config.colors.primaryTitreSelect),
                        ),
                      );
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
