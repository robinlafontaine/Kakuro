import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:kakuro/widgets/popup.dart';

class Classement extends StatefulWidget {
  const Classement({super.key});

  @override
  //Leaderboard.getLeaderboard(limite)
  State<Classement> createState() => ClassementState();
}

class ClassementState extends State<Classement> {
  final Future scoresFuture = Leaderboard.getLeaderboard();

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
                  future: scoresFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      bool cache = snapshot.data.metadata.isFromCache;
                      if (cache) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Popup.showAlert(context);
                        });
                      }
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
                                      width: width(context) / 5,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Center(
                                          child: Text(
                                        "RANG",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ))),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 2.7,
                                      height: 40,
                                      child: Text(
                                        "JOUEUR",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      )),
                                  Container(
                                      width: width(context) / 3.3,
                                      height: 40,
                                      child: Center(
                                          child: Text(
                                        "POINTS",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ))),
                                ],
                              ),
                            ),
                            for (int i = 0; i < snapshot.data.docs.length; i++)
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
                                        width: width(context) / 5,
                                        height: 40,
                                        child: Center(
                                            child: Text(
                                          (i + 1).toString(),
                                          style: TextStyle(
                                              fontWeight:
                                                  (snapshot.data.docs[i].id ==
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                        ))),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 2.7,
                                        height: 40,
                                        child: Text(
                                          snapshot.data.docs[i].id ==
                                                  FirebaseAuth
                                                      .instance.currentUser?.uid
                                              ? "Moi"
                                              : snapshot.data.docs[i]["name"],
                                          style: TextStyle(
                                              fontWeight:
                                                  (snapshot.data.docs[i].id ==
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                        )),
                                    Container(
                                        width: width(context) / 3.3,
                                        height: 40,
                                        child: Center(
                                            child: Text(
                                          snapshot.data.docs[i]["score"]
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight:
                                                  (snapshot.data.docs[i].id ==
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                        ))),
                                  ],
                                ),
                              ),
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
