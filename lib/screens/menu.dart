import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/mes_parties.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';
import 'package:kakuro/screens/parametres.dart';

import '../auth.dart';
import '../Config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Config.colors.primaryBackground,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, width(context) / 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Appbar(home: true, enjeu: false, retour: () => {}),
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
                ElevatedButton(
                  onPressed: () {
                    route(context, const NouvellePartie());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.colors.primarySelect,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.05), // Change the height to 40 pixels
                  ),
                  child: const Text(
                    "NOUVELLE PARTIE",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    route(context, const MesParties());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.colors.primarySelect,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.05), // Change the height to 40 pixels
                  ),
                  child: const Text(
                    "MES PARTIES",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => {
                    Auth(FirebaseAuth.instance)
                        .signedIn()
                        .then(((connected) => {
                              if (!connected)
                                {
                                  Auth(FirebaseAuth.instance)
                                      .signInGoogle(context)
                                      .then((value) => Leaderboard()
                                          .userExists(context)
                                          .then((value) => {
                                                if (FirebaseAuth
                                                        .instance.currentUser !=
                                                    null)
                                                  route(context,
                                                      const Multijoueur())
                                              }))
                                }
                              else
                                {
                                  Config.online = true,
                                  route(context, const Multijoueur())
                                }
                            }))
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.colors.primarySelect,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) *
                          0.20, // Change the horizontal padding to 20% of the screen width
                    ),
                    minimumSize: Size(
                        width(context) * 0.90,
                        height(context) *
                            0.05), // Change the height to 40 pixels
                  ),
                  child: const Text(
                    "MULTIJOUEUR",
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
