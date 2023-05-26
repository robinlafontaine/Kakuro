import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/mes_parties.dart';
import 'package:kakuro/screens/nouvelle_partie.dart';

import '../screens/menu.dart';

class Navbar extends StatelessWidget {
  final int actif;
  final Function reaload;
  final Function? checkGrille;

  const Navbar(
      {super.key,
      required this.actif,
      required this.reaload,
      this.checkGrille});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // elevation: 100,
      backgroundColor:
          Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: 'Accueil',
        ),
        // route to menu
        NavigationDestination(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          selectedIcon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: 'Nouvelle partie',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.gamepad,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          selectedIcon: Icon(
            Icons.gamepad,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: 'Mes parties',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          selectedIcon: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: 'Paramètres',
        ),
      ],
      selectedIndex: actif,
      onDestinationSelected: (index) {
        if (checkGrille != null) {
          checkGrille!();
        }
        switch (index) {
          case 0:
            route(context, const Menu());
            break;
          case 1:
            route(context, const NouvellePartie());
            break;
          case 2:
            route(context, const MesParties());
            break;
          case 3:
            reaload();
            break;
          default:
            // do nothing
            break;
        }
      },
    );
  }
}
