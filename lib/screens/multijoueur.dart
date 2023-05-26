import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/classement.dart';
import 'package:kakuro/screens/invitation.dart';
import 'package:kakuro/screens/mes_parties_multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/resultat.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'menu.dart';

class Multijoueur extends StatefulWidget {
  const Multijoueur({super.key});

  @override
  State<Multijoueur> createState() => MultijoueurState();
}

class MultijoueurState extends State<Multijoueur> {
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: Image.asset(
                    Config.images.icon,
                    width: width(context) / 2,
                    height: width(context) / 2,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    route(context, const Invitation());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.08), // Change the height to 40 pixels
                  ),
                  child: Text(
                    "LANCER DUEL",
                    selectionColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    route(context, const MesPartiesMultijoueur());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.08), // Change the height to 40 pixels
                  ),
                  child: Text(
                    "MES PARTIES",
                    selectionColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    route(context, const Resultat());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.08), // Change the height to 40 pixels
                  ),
                  child: Text(
                    "RESULTATS",
                    selectionColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    route(context, const Classement());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.08), // Change the height to 40 pixels
                  ),
                  child: Text(
                    "CLASSEMENT",
                    selectionColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Navbar(
              actif: 0,
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
