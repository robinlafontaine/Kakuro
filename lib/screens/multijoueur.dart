import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/widgets/boutton.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class multijoueur extends StatefulWidget{

  @override
  State<multijoueur> createState() => _multijoueurState();
}

class _multijoueurState extends State<multijoueur> {

  void retour(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:false,retour: ()=>{retour()}, enligne: true,),
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
                value: "ENVOYER INVITATION",
                onPress: (){}
            ),
            SizedBox(
              height: 10,
            ),
            boutton(
                value: "MES PARTIES",
                onPress: (){}
            ),
            SizedBox(
              height: 10,
            ),
            boutton(
                value: "RESULTATS",
                onPress: (){}
            ),
            SizedBox(
              height: 10,
            ),
            boutton(
                value: "CLASSEMENT",
                onPress: (){}
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(10, true),
    );
  }
}