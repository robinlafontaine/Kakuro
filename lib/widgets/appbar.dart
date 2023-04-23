import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/screens/abandon.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';

class appbar extends StatefulWidget{
  final bool home;
  final bool enjeu;
  final Function retour;
  final bool? enligne;

  appbar({required this.home,required this.enjeu,required this.retour, this.enligne});

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
      leadingWidth: widget.home?width(context)/3:width(context)/8.5,
      centerTitle: true,
      leading: (widget.home)
          ?
          Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                    color: config.colors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width(context)/20,
                          height: width(context)/20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: (widget.enligne==null)?Colors.red:
                            (widget.enligne==true)?Colors.green:Colors.red
                          ),
                        ),
                        Text( (widget.enligne==null)?
                          "Hors ligne":(widget.enligne==true)?"En ligne":"Hors ligne",
                          style: TextStyle(
                            fontSize: width(context)/25
                          ),
                        )
                      ],
                    ),
                    onTap: (){
                      (widget.enligne==null)?null:
                      (widget.enligne==true)?route(context, horsligne()):
                          route(context, enligne());
                    },
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
          ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.timer, size: width(context)/12,color: Colors.black,),
              SizedBox(
                width: 5,
              ),
              Text("$minute:$seconde",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: width(context)/11
                  )
                ,),
            ],
          )
          :null,

      actions: [ (widget.enjeu) ?
        Container(
          width: width(context)/8.5,
            decoration: BoxDecoration(
              color: config.colors.primaryColor,
              borderRadius: BorderRadius.circular(100)
            ),
            child: Center(
                child: InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.ban,
                    size: width(context)/20,
                  ),
                  onTap: (){
                    (enligne==null)?null:
                    (enligne==true)?route(context, abandon(true)):
                    route(context, abandon(false));
                  },
                )
            )
        ) :
        SizedBox(
          width: 0.0001,
        )
      ],
    );
  }
}