import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/duels.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import '../Config/fonctions.dart';
import '../leaderboard.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class Resultat extends StatefulWidget {
  const Resultat({super.key});

  @override
  //Leaderboard.getLeaderboard(limite)
  State<Resultat> createState() => ResultatState();
}

class ResultatState extends State<Resultat> {
  final Future resFuture = Duels.getFinishedDuels(FirebaseAuth.instance.currentUser?.uid);

  void retour() {
    route(context, const Multijoueur());
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
              child: FutureBuilder(
                  future: resFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print("LAAAA");
                      print(snapshot);
                      //bool cache = snapshot.data.metadata.isFromCache;
                      //print("cache?: $cache");
                      //TODO : afficher un message pour dire si les données sont a jour ou non !
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              width: width(context) / 1.1,
                              child: Row(
                                children: [
                                  Container(
                                      width: width(context) / 6,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Center(
                                          child: Text(
                                            "JOUEUR",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer),
                                          ))),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 6,
                                      height: 40,
                                      child: Text(
                                        "T1",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 6,
                                      height: 40,
                                      child: Text(
                                        "T2",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 6,
                                      height: 40,
                                      child: Text(
                                        "GRILLE",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 6,
                                      height: 40,
                                      child: Text(
                                        "DIFFICULTE",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                ],
                              ),
                            ),
                            for (int i = 0; i < snapshot.data.length; i++)
                              Container(
                                width: width(context) / 1.1,
                                decoration: BoxDecoration(
                                    color: (i % 2 == 0)
                                        ? Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
                                        .withOpacity(0.5)
                                        : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
                                        .withOpacity(0.2)),
                                child: Row(
                                  children: [
                                    Container(
                                        margin:
                                        const EdgeInsets.only(right: 10),
                                        width: width(context) / 6,
                                        height: 40,
                                        child: Center(
                                            child: Text("on verra"))),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 6,
                                        height: 40,
                                        child: Text(snapshot.data.docs[i]["player"][0])),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 6,
                                        height: 40,
                                        child: Text(snapshot.data.docs[i]["player"][1])),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 6,
                                        height: 40,
                                        child: Text(snapshot.data.docs[i]["board"])),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 6,
                                        height: 40,
                                        child: Text(snapshot.data.docs[i]["difficulty"])),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Erreur");
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
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
