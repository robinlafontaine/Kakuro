import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import '../config/fonctions.dart';
import '../leaderboard.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class invitation extends StatefulWidget {
  var player;

  invitation(this.player);

  @override
  State<invitation> createState() => invitationState();
}

class invitationState extends State<invitation> {
  String ligne = "2", colonne = "2", diff = "1", adversaire = "";
  var items = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  var difficulte = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  final Future playersFuture = Leaderboard.getPlayers();

  @override
  void initState() {
    super.initState();
    ligne = items[0];
    colonne = items[0];
    diff = difficulte[0];
  }

  void retour() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context) / 6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home: false, enjeu: false, retour: retour),
        ),
      ),
      body: Center(
          child: FutureBuilder(
              future: playersFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem<String>> joueurs = [];
                  print(snapshot.data.runtimeType);
                  // for (var document in snapshot.data) {
                  //   String name = document['name'];
                  //   String documentId = document.id;
                  //   joueurs.add(DropdownMenuItem(
                  //     value: documentId,
                  //     child: Text(name),
                  //   ));
                  // }
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height(context) / 10,
                          ),
                          Text(
                            "Adversaire",
                            style: TextStyle(
                                fontSize: width(context) / 21,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: width(context) / 1.1,
                            decoration: BoxDecoration(
                                color: config.colors.primaryTextColor),
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: adversaire,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: joueurs,
                                  onChanged: (String? value) {
                                    setState(() {
                                      adversaire = value!;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Taille de la grille",
                            style: TextStyle(
                                fontSize: width(context) / 21,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: config.colors.primaryTextColor),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: ligne,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: items.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Container(
                                            child: Text(items),
                                            width: width(context) / 4,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          value == null ? "" : ligne = value;
                                        });
                                      }),
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.xmark,
                                size: width(context) / 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: config.colors.primaryTextColor),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: colonne,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: items.map((items) {
                                        return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                              child: Text(items),
                                              width: width(context) / 4,
                                            ));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          value == null ? "" : colonne = value;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Niveau de difficulté",
                            style: TextStyle(
                                fontSize: width(context) / 21,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: width(context) / 1.1,
                            decoration: BoxDecoration(
                                color: config.colors.primaryTextColor),
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: diff,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: difficulte.map((items) {
                                    return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                          child: Text(items),
                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      value == null ? "" : diff = value;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          boutton(
                              value: "LANCER LA PARTIE",
                              onPress: () {
                                route(
                                    context,
                                    game(
                                        Kakuro(
                                            int.parse(ligne),
                                            int.parse(colonne),
                                            int.parse(diff)),
                                        true,widget.player));
                              })
                        ]),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              })),
      bottomNavigationBar: navbar(1, true, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => parametre(true, widget,widget.player))).then((value) {
          setState(() {});
        });
      },widget.player),
    );
  }
}
