import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';

class appbar extends StatelessWidget{
  final bool home;
  final bool enjeu;

  appbar(this.home,this.enjeu);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: config.colors.gris,
      elevation: 0,
      leadingWidth: 40,
      centerTitle: true,
      leading: (home)
          ?
          Builder(
            builder: (BuildContext context) {
              return Container(
                child: Center(
                  child: IconButton(
                    icon: FaIcon(
                        FontAwesomeIcons.navicon
                    ),
                    iconSize: 21,
                    color: config.colors.primaryColor,
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              );
            },
          )
          :
          Builder(
            builder: (BuildContext context) {
              return Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  color: config.colors.primaryColor
                ),
                child: Center(
                  child: IconButton(
                    icon: FaIcon(
                        FontAwesomeIcons.arrowLeftLong
                    ),
                    iconSize: 13,
                    color: config.colors.primaryTextColor,
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              );
            },
          ),

      title: (enjeu)?Text("TIMER", style: TextStyle(color: config.colors.primaryColor),):null,
    );
  }


}