import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/classement.dart';
import 'package:kakuro/screens/invitation.dart';
import 'package:kakuro/screens/mes_parties_multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/resultat.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/bouttonmd3.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:kakuro/widgets/popup.dart';
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
                BouttonMd3(
                    onTap: () {
                      route(context, const Invitation());
                    },
                    text: 'LANCER UN DUEL'),
                const SizedBox(
                  height: 10,
                ),
                BouttonMd3(
                    onTap: () {
                      route(context, const MesPartiesMultijoueur());
                    },
                    text: 'MES PARTIES'),
                const SizedBox(
                  height: 10,
                ),
                BouttonMd3(
                    onTap: () {
                      route(context, const Resultat());
                    },
                    text: 'RESULTATS'),
                const SizedBox(
                  height: 10,
                ),
                BouttonMd3(
                    onTap: () {
                      route(context, const Classement());
                    },
                    text: 'CLASSEMENT'),
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
