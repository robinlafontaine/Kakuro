import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';

import '../Config/fonctions.dart';
import '../leaderboard.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

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
              child: FutureBuilder(
                  future: scoresFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Config.colors.primaryColor),
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
                                            color:
                                                Config.colors.primaryTextColor),
                                      ))),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: width(context) / 2.7,
                                      height: 40,
                                      child: Text("JOUEUR",
                                          style: TextStyle(
                                              color: Config
                                                  .colors.primaryTextColor))),
                                  Container(
                                      width: width(context) / 3.3,
                                      height: 40,
                                      child: Center(
                                          child: Text("POINTS",
                                              style: TextStyle(
                                                  color: Config.colors
                                                      .primaryTextColor)))),
                                ],
                              ),
                            ),
                            for (int i = 0; i < snapshot.data.length; i++)
                              Container(
                                width: width(context) / 1.1,
                                decoration: BoxDecoration(
                                    color: (i % 2 == 0)
                                        ? Config.colors.primaryTextColor
                                        : Colors.white54),
                                child: Row(
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: width(context) / 5,
                                        height: 40,
                                        child: Center(
                                            child: Text((i + 1).toString()))),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: width(context) / 2.7,
                                        height: 40,
                                        child: Text(snapshot.data[i].id ==
                                                FirebaseAuth
                                                    .instance.currentUser?.uid
                                            ? "Moi"
                                            : snapshot.data[i]["name"])),
                                    Container(
                                        width: width(context) / 3.3,
                                        height: 40,
                                        child: Center(
                                            child: Text(snapshot.data[i]
                                                    ["score"]
                                                .toString()))),
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
              actif: 10,
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
