import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';

class navbar extends StatelessWidget{
  final int actif;

  navbar(this.actif);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context)/12,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: config.colors.primaryColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: null,
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: (actif!=0)?config.colors.gris:config.colors.primaryTextColor,
                size: height(context)/35,
              ),
          ),

          IconButton(
            onPressed: null,
            icon: FaIcon(
              FontAwesomeIcons.plus,
              color: (actif!=1)?config.colors.gris:config.colors.primaryTextColor,
              size: height(context)/35,
            ),
          ),
          IconButton(
            onPressed: null,
            icon: FaIcon(
              FontAwesomeIcons.gamepad,
              color: (actif!=2)?config.colors.gris:config.colors.primaryTextColor,
              size: height(context)/35,
            ),
          ),
          IconButton(
            onPressed: null,
            icon: FaIcon(
              FontAwesomeIcons.cogs,
              color: (actif!=3)?config.colors.gris:config.colors.primaryTextColor,
              size: height(context)/35,
            ),
          ),
        ],
      ),
    );
  }

}