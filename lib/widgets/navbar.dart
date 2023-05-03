import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/mesparties.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';

class navbar extends StatelessWidget {
  final int actif;
  final Function reaload;
  final Function? checkGrille;

  const navbar({super.key, required this.actif, required this.reaload, this.checkGrille});

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
            onPressed: (){
              if(checkGrille!=null){
                checkGrille!();
              }
              if(config.online){
                route(context, enligne());
              }else {
                route(context, horsligne());
              }
            },
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: (actif != 0)
                  ? config.colors.primaryNavIcon
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              if(checkGrille!=null)checkGrille!();
              route(context, nouvellepartie());
            },
            icon: FaIcon(
              FontAwesomeIcons.plus,
              color: (actif != 1)
                  ? config.colors.primaryNavIcon
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: (){
              if(checkGrille!=null) {
                checkGrille!();
              }
              route(context, mesparties());

            },
            icon: FaIcon(
              FontAwesomeIcons.gamepad,
              color: (actif != 2)
                  ? config.colors.primaryNavIcon
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
          IconButton(
            onPressed: () {
              reaload();
              if(checkGrille!=null) checkGrille!();
            },
            icon: FaIcon(
              FontAwesomeIcons.gears,
              color: (actif != 3)
                  ? config.colors.primaryNavIcon
                  : config.colors.primaryTextColor,
              size: height(context) / 35,
            ),
          ),
        ],
      ),
    );
  }
}
