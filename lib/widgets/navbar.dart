import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';

class navbar extends StatelessWidget {
  final int actif;
  final bool online;
  final Function reaload;
  final player;

  navbar(this.actif, this.online, this.reaload,this.player);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context) / 12,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: config.colors.primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              (online)
                  ? route(context, enligne(player))
                  : route(context, horsligne(player));
            },
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: (actif != 0)
                  ? config.colors.primaryBackground
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              route(context, nouvellepartie(online,player));
            },
            icon: FaIcon(
              FontAwesomeIcons.plus,
              color: (actif != 1)
                  ? config.colors.primaryBackground
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: null,
            icon: FaIcon(
              FontAwesomeIcons.gamepad,
              color: (actif != 2)
                  ? config.colors.primaryBackground
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              //route(context, parametre(online,widgetBack));
              reaload();
            },
            icon: FaIcon(
              FontAwesomeIcons.gears,
              color: (actif != 3)
                  ? config.colors.primaryBackground
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
        ],
      ),
    );
  }
}
