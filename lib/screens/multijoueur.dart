import 'package:flutter/material.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/screens/classement.dart';
import 'package:kakuro/screens/invitation.dart';
import 'package:kakuro/screens/mes_parties_multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/Boutton.dart';

import '../Config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
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
          backgroundColor: Config.colors.primaryBackground,
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
                Image.asset(
                  Config.images.icon,
                  width: width(context) / 2,
                  height: width(context) / 2,
                ),
                const SizedBox(
                  height: 40,
                ),
                Boutton(
                    value: "LANCER DUEL",
                    onPress: () {
                      route(context, const Invitation());
                    }),
                const SizedBox(
                  height: 10,
                ),
                Boutton(
                    value: "MES PARTIES",
                    onPress: () {
                      // route(context, const MesPartiesMultijoueur());
                    }),
                const SizedBox(
                  height: 10,
                ),
                Boutton(value: "RESULTATS", onPress: () {}),
                const SizedBox(
                  height: 10,
                ),
                Boutton(
                    value: "CLASSEMENT",
                    onPress: () {
                      route(context, const Classement());
                    }),
              ],
            ),
          ),
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
