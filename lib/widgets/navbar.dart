import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/Config/fonctions.dart';
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
    return Container(
      width: width(context),
      height: height(context) / 12,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Config.colors.primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              if (checkGrille != null) {
                checkGrille!();
              }
              route(context, const Menu());
            },
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: (actif != 0)
                  ? Config.colors.primaryNavIcon
                  : Config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              if (checkGrille != null) checkGrille!();
              route(context, const NouvellePartie());
            },
            icon: FaIcon(
              FontAwesomeIcons.plus,
              color: (actif != 1)
                  ? Config.colors.primaryNavIcon
                  : Config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              if (checkGrille != null) {
                checkGrille!();
              }
              route(context, const MesParties());
            },
            icon: FaIcon(
              FontAwesomeIcons.gamepad,
              color: (actif != 2)
                  ? Config.colors.primaryNavIcon
                  : Config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              reaload();
              if (checkGrille != null) checkGrille!();
            },
            icon: FaIcon(
              FontAwesomeIcons.gears,
              color: (actif != 3)
                  ? Config.colors.primaryNavIcon
                  : Config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
        ],
      ),
    );
  }
}
