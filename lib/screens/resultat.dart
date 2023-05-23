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


  String getAffichage(int n) {
    return n.toString().padLeft(2, "0");
  }

  String getSeconde(int seconde) {
     Duration duration = Duration(seconds: seconde);
     return getAffichage(duration.inSeconds.remainder(60));
  }

  String getMinute(int seconde) {
    Duration duration = Duration(seconds: seconde);
    return getAffichage(duration.inMinutes.remainder(60));
  }

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
                      print(snapshot.data[0].docs[0]["difficulty"]);
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
                                      width: width(context)/5,
                                      height: 40,
                                      margin: const EdgeInsets.only( left: 10),
                                      child: Center(
                                          child: Text(
                                            "Joueur",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer),
                                          ))),
                                  Container(
                                      alignment: Alignment.center,
                                      width: width(context) / 7,
                                      height: 40,
                                      child: Text(
                                        "T1",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: width(context) / 7,
                                      height: 40,
                                      child: Text(
                                        "T2",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: width(context) / 7,
                                      height: 40,
                                      child: Text(
                                        "Grille",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: width(context) / 4,
                                      height: 40,
                                      child: Text(
                                        "Difficulté",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                ],
                              ),
                            ),
                            for (int i = 0; i < snapshot.data[0].docs.length; i++)
                              Container(
                                width: width(context) / 1.1,
                                decoration: BoxDecoration(
                                    color:
                                    (snapshot.data[0].docs[i]["winner"]=="draw")?
                                      Colors.orange
                                    :(snapshot.data[0].docs[i]["winner"]==FirebaseAuth.instance.currentUser?.uid)?
                                      Colors.green
                                    :Colors.redAccent
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        margin:
                                        const EdgeInsets.only(left: 10),
                                        width: width(context)/5,
                                        height: 60,
                                        child: Center(
                                            child: Text(snapshot.data[1][i]))),
                                    Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 7,
                                        height: 60,
                                        child: Text(
                                            (snapshot.data[0].docs[i]['timers'].values.toList()[0] == -1)?"N/A":
                                            "${getMinute(snapshot.data[0].docs[i]['timers'].values.toList()[0])}:"
                                                "${getSeconde(snapshot.data[0].docs[i]['timers'].values.toList()[0])}"
                                        )
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 7,
                                        height: 60,
                                        child: Text(
                                        (snapshot.data[0].docs[i]['timers'].values.toList()[1] == -1)?"N/A":
                                          "${getMinute(snapshot.data[0].docs[i]['timers'].values.toList()[1])}:"
                                          "${getSeconde(snapshot.data[0].docs[i]['timers'].values.toList()[1])}"
                                        )
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 7,
                                        height: 60,
                                        child: Text(snapshot.data[0].docs[i]["board"])),
                                    Container(
                                        alignment: Alignment.center,
                                        width: width(context) / 4,
                                        height: 60,
                                        child: Text(snapshot.data[0].docs[i]["difficulty"].toString())),
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
