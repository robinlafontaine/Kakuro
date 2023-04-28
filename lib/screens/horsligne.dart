import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class horsligne extends StatefulWidget{


  @override
  State<horsligne> createState() => _horsligneState();
}

class _horsligneState extends State<horsligne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home: true,enjeu:false,retour:()=>{}, enligne: false,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              config.images.icon,
              width: width(context)/2,
              height: height(context)/2,
            ),
            boutton(
                value: "NOUVELLE PARTIE",
                onPress: (){route(context, nouvellepartie(false));}
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
      bottomNavigationBar: navbar(0, false,(){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => parametre(false,this))).then((value) { setState(() {});});
    }));
  }
}