import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import '../Config/fonctions.dart';
import '../leaderboard.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class Invitation extends StatefulWidget {
  const Invitation({super.key});

  @override
  State<Invitation> createState() => InvitationState();
}

class InvitationState extends State<Invitation> {
  String ligne = "6", colonne = "6", diff = "1", adversaire = "";
  var items = ["5", "6", "7", "8", "9", "10"];
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
            child: Appbar(home: false, enjeu: false, retour: retour),
          ),
        ),
        body: Center(
            child: FutureBuilder(
                future: playersFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    // empty map
                    Map<String, String> data = {};
                    for (var document in snapshot.data) {
                      String name = document['name'];
                      String documentId = document.id;
                      // add document id to list
                      data[name] = documentId;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height(context) / 10,
                            ),
                            // textbox where you can type player name
                            Text(
                              "Adversaire",
                              style: TextStyle(
                                  fontSize: width(context) / 21,
                                  fontWeight: FontWeight.w600,
                                  color: Config.colors.primaryTitreSelect),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // raw autocomplete
                            RawAutocomplete(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return data.keys.where((String option) {
                                  return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (String selection) async {
                                // invite(selection, data[selection]);
                                // popup with name and uid
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Inviter $selection'),
                                      content: Text(
                                          'Voulez-vous inviter $selection ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annuler'),
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // await invite(selection, data[selection]);
                                            Navigator.pop(context, 'Inviter');
                                          },
                                          child: const Text('Inviter'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) async {
                                    // invite(value);
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nom de l\'adversaire',
                                  ),
                                );
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<String> onSelected,
                                  Iterable<String> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    child: SizedBox(
                                      height: 200.0,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String option =
                                              options.elementAt(index);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(option),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            Container(
                              width: width(context) / 1.1,
                              decoration: BoxDecoration(
                                  color: Config.colors.primarySelect),
                              padding:
                                  const EdgeInsets.only(left: 15, right: 10),
                              // child: DropdownButtonHideUnderline(
                              //   child: DropdownButton<String>(
                              //       dropdownColor:
                              //           Config.colors.primarySelectItem,
                              //       value: adversaire,
                              //       icon: Icon(
                              //         Icons.keyboard_arrow_down,
                              //         color: Config.colors.primaryTextBlack,
                              //       ),
                              //       items: joueurs,
                              //       onChanged: (String? value) {
                              //         setState(() {
                              //           adversaire = value!;
                              //         });
                              //       }),
                              // ),
                            ),
                            const SizedBox(
                              height: 30,
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
                                  decoration: BoxDecoration(
                                      color: Config.colors.primarySelect),
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        dropdownColor:
                                            Config.colors.primarySelectItem,
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
                                                    color: Config.colors
                                                        .primaryTextBlack),
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
                                  color: Config.colors.primaryTitreSelect,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Config.colors.primarySelect),
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        dropdownColor:
                                            Config.colors.primarySelectItem,
                                        value: colonne,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Config.colors.primaryTextBlack,
                                        ),
                                        items: items.map((items) {
                                          return DropdownMenuItem(
                                              value: items,
                                              child: Container(
                                                width: width(context) / 4,
                                                child: Text(items,
                                                    style: TextStyle(
                                                        color: Config.colors
                                                            .primaryTextBlack)),
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            value == null
                                                ? ""
                                                : colonne = value;
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
                              decoration: BoxDecoration(
                                  color: Config.colors.primarySelect),
                              padding:
                                  const EdgeInsets.only(left: 15, right: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    dropdownColor:
                                        Config.colors.primarySelectItem,
                                    value: diff,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Config.colors.primaryTextBlack,
                                    ),
                                    items: difficulte.map((items) {
                                      return DropdownMenuItem(
                                          value: items,
                                          child: Container(
                                            child: Text(items,
                                                style: TextStyle(
                                                    color: Config.colors
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
                            Boutton(
                                value: "LANCER LE DUEL",
                                onPress: () {
                                  route(
                                      context,
                                      Game(
                                        kakuro: Kakuro(
                                            int.parse(ligne),
                                            int.parse(colonne),
                                            int.parse(diff)),
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
        bottomNavigationBar: Navbar(
            actif: 1,
            reaload: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Parametre())).then((value) {
                setState(() {});
              });
            }),
      ),
    );
  }
}
