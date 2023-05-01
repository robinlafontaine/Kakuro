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

class invitation extends StatefulWidget {
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
    adversaire = "";
  }

  void retour() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        retour();
        return true;
      },
      child: Scaffold(
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
                    List<DropdownMenuItem<String>> joueurs = [
                      DropdownMenuItem(
                        value: "",
                        enabled: false,
                        child: Text("Choisissez un Adversaire...", style: TextStyle(color: config.colors.primaryTextBlack),),
                      )
                    ];
                    for (var document in snapshot.data) {
                      String name = document['name'];
                      String documentId = document.id;
                      joueurs.add(
                          DropdownMenuItem(value: documentId, child: Text(name, style: TextStyle(color: config.colors.primaryTextBlack),)));
                    }
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
                                  fontWeight: FontWeight.w600,
                                  color: config.colors.primaryTitreSelect),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width(context) / 1.1,
                              decoration: BoxDecoration(
                                  color: config.colors.primarySelect),
                              padding: const EdgeInsets.only(left: 15, right: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    dropdownColor: config.colors.primarySelectItem,
                                    value: adversaire,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: config.colors.primaryTextBlack,
                                    ),
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
                                  fontWeight: FontWeight.w600,
                                  color: config.colors.primaryTitreSelect),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: config.colors.primarySelect),
                                  padding:
                                      const EdgeInsets.only(left: 15, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        dropdownColor:
                                            config.colors.primarySelectItem,
                                        value: ligne,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: config.colors.primaryTextBlack,
                                        ),
                                        items: items.map((items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                              width: width(context) / 4,
                                              child: Text(
                                                items,
                                                style: TextStyle(
                                                    color: config
                                                        .colors.primaryTextBlack),
                                              ),
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
                                  color: config.colors.primaryTitreSelect,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: config.colors.primarySelect),
                                  padding:
                                      const EdgeInsets.only(left: 15, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        dropdownColor:
                                            config.colors.primarySelectItem,
                                        value: colonne,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: config.colors.primaryTextBlack,
                                        ),
                                        items: items.map((items) {
                                          return DropdownMenuItem(
                                              value: items,
                                              child: Container(
                                                width: width(context) / 4,
                                                child: Text(items,
                                                    style: TextStyle(
                                                        color: config.colors
                                                            .primaryTextBlack)),
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
                                  fontWeight: FontWeight.w600,
                                  color: config.colors.primaryTitreSelect),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width(context) / 1.1,
                              decoration: BoxDecoration(
                                  color: config.colors.primarySelect),
                              padding: const EdgeInsets.only(left: 15, right: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    dropdownColor:
                                        config.colors.primarySelectItem,
                                    value: diff,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: config.colors.primaryTextBlack,
                                    ),
                                    items: difficulte.map((items) {
                                      return DropdownMenuItem(
                                          value: items,
                                          child: Container(
                                            child: Text(items,
                                                style: TextStyle(
                                                    color: config.colors
                                                        .primaryTextBlack)),
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
                                      game(kakuro:
                                        Kakuro(int.parse(ligne),
                                            int.parse(colonne), int.parse(diff)),
                                      ));
                                })
                          ]),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return const CircularProgressIndicator();
                  }
                })),
        bottomNavigationBar: navbar(actif:1, reaload:() {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => parametre()))
              .then((value) {
            setState(() {});
          });
        }),
      ),
    );
  }
}
