import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/mes_parties.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/auth.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/bouttonmd3.dart';
import 'package:kakuro/widgets/navbar.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {


  @override
  void initState() {
    if(Config.wingame)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        openDialogVictoire();
      });
    Config.wingame = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
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
                      route(context, const NouvellePartie());
                    },
                    text: "NOUVELLE PARTIE"),
                const SizedBox(
                  height: 20,
                ),
                BouttonMd3(
                    onTap: () {
                      route(context, const MesParties());
                    },
                    text: "MES PARTIES"),
                const SizedBox(
                  height: 20,
                ),
                BouttonMd3(
                    onTap: () {
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
                                                  if (FirebaseAuth.instance
                                                          .currentUser !=
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
                              }));
                    },
                    text: "MULTIJOUEUR"),
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

  Future openDialogVictoire() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Victoire'),
        content: const Text('Félicitation, vous avez gagné !'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(
                    color:
                    Theme.of(context).colorScheme.onSecondaryContainer),
              ))
        ],
      ));

}
