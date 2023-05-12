import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import '../Config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'menu.dart';

class NouvellePartie extends StatefulWidget {
  const NouvellePartie({super.key});

  @override
  State<NouvellePartie> createState() => NouvellePartieState();
}

class NouvellePartieState extends State<NouvellePartie> {
  String ligne = "4", colonne = "4", diff = "Facile";
  var items = [
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];
  var difficulte = ["Facile", "Moyen", "Difficile"];

  @override
  void initState() {
    super.initState();
    ligne = items[0];
    colonne = items[0];
    diff = difficulte[0];
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
              child: Appbar(home: false, enjeu: false, retour: retour),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height(context) / 10,
                    ),
                    Text(
                      "Taille de la grille",
                      style: TextStyle(
                          fontSize: width(context) / 21,
                          fontWeight: FontWeight.w600,
                          color: Config.colors.primaryTitreSelect),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: Config.colors.primarySelect),
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                dropdownColor: Config.colors.primarySelectItem,
                                value: ligne,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Config.colors.primaryTextBlack,
                                ),
                                items: items.map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Container(
                                      width: width(context) / 4,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                            color:
                                                Config.colors.primaryTextBlack),
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
                        FaIcon(FontAwesomeIcons.xmark,
                            size: width(context) / 20,
                            color: Config.colors.primaryTitreSelect),
                        Container(
                          decoration:
                              BoxDecoration(color: Config.colors.primarySelect),
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                dropdownColor: Config.colors.primarySelectItem,
                                value: colonne,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Config.colors.primaryTextBlack),
                                items: items.map((items) {
                                  return DropdownMenuItem(
                                      value: items,
                                      child: Container(
                                        width: width(context) / 4,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                              color: Config
                                                  .colors.primaryTextBlack),
                                        ),
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
                          color: Config.colors.primaryTitreSelect),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width(context) / 1.1,
                      decoration:
                          BoxDecoration(color: Config.colors.primarySelect),
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            dropdownColor: Config.colors.primarySelectItem,
                            value: diff,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Config.colors.primaryTextBlack,
                            ),
                            items: difficulte.map((items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                    child: Text(
                                      items,
                                      style: TextStyle(
                                          color:
                                              Config.colors.primaryTextBlack),
                                    ),
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
                    Boutton(
                        value: "LANCER LA PARTIE",
                        onPress: () {
                          Config.newgame = true;
                          route(
                              context,
                              Game(
                                kakuro: Kakuro(
                                    int.parse(ligne) - 1,
                                    int.parse(colonne) - 1,
                                    (diff == difficulte[0])
                                        ? 4
                                        : (diff == difficulte[1])
                                            ? 7
                                            : 10),
                              ));
                        })
                  ]),
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 0,
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
