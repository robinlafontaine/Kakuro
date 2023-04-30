import 'package:audioplayers/src/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class enligne extends StatefulWidget{
  var player;

  enligne(AudioPlayer player);
  @override
  State<enligne> createState() => _enligneState();
}

class _enligneState extends State<enligne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:true,enjeu:false,retour: ()=>{}, enligne: true,),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              config.images.icon,
              width: width(context)/2,
              height: width(context)/2,
            ),
            SizedBox(height: 40,),
            boutton(
                value: "NOUVELLE PARTIE",
                onPress: (){route(context, nouvellepartie(true,widget.player));}
            ),
            SizedBox(
              height: 10,
            ),
            boutton(
                value: "MULTIJOUEUR",
                onPress: (){route(context, multijoueur(widget.player));}
            ),
            SizedBox(
              height: 10,
            ),
            boutton(
                value: "MES PARTIES",
                onPress: (){}
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(0, true,(){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => parametre(true,this,widget.player))).then((value) { setState(() {});});}
          ,widget.player));
  }
}