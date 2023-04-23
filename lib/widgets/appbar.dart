import 'dart:async';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';

class appbar extends StatefulWidget{
  final bool home;
  final bool enjeu;
  final Function retour;

  appbar(this.home,this.enjeu, this.retour);

  @override
  State<appbar> createState() => _appbarState(this.retour);
}

class _appbarState extends State<appbar> {
  String time="0", seconde="00",minute="00";
  Timer? timer;
  Function retour;
  Duration duration = Duration();

  _appbarState(this.retour);

  @override
  void initState(){
    super.initState();
    startTimer();
  }

  String getAffichage(int n){
    return n.toString().padLeft(2,"0");
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1),(_) => addTime());
  }

  void addTime(){
    final addSeconds = 1;
    if (this.mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
        minute = getAffichage(duration.inMinutes.remainder(60));
        seconde = getAffichage(duration.inSeconds.remainder(60));
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: config.colors.gris,
      elevation: 0,
      leadingWidth: width(context)/8.5,
      centerTitle: true,
      leading: (widget.home)
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
                    onPressed: (){widget.retour;},
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  color: config.colors.primaryColor
                ),
                child: Center(
                  child: IconButton(
                    icon: FaIcon(
                        FontAwesomeIcons.arrowLeftLong
                    ),
                    iconSize: width(context)/20,
                    color: config.colors.primaryTextColor,
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      widget.retour();
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              );
            },
          ),

      title: (widget.enjeu)
          ? Text("$minute:$seconde",
              style: TextStyle(
                color: config.colors.primaryColor,
                fontSize: width(context)/14
              )
            ,)
          :null,
    );
  }
}