import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/mes_parties.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/Boutton.dart';

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
                Boutton(
                    value: "NOUVELLE PARTIE",
                    onPress: () {
                      route(context, const NouvellePartie());
                    }),
                const SizedBox(
                  height: 10,
                ),
                Boutton(
                    value: "MES PARTIES",
                    onPress: () {
                      route(context, const MesParties());
                    }),
                // FilledButton.tonal(
                //   onPressed: () {
                //     route(context, const MesParties());
                //   },
                //   // style to text to whole width
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     minimumSize: const Size(200, 50),
                //   ),
                //   child: const Text(
                //     "MES PARTIES",
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Boutton(
                  value: "MULTIJOUEUR",
                  onPress: () => {
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
