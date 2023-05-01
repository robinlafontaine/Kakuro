import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/classement.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/invitation.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';
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
    route(context, enligne());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:false,retour: ()=>{retour()}),
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
                onPress: (){
                  route(context, invitation());
                }
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
                onPress: (){route(context, classement());}
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(actif:10,reaload:(){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => parametre())).then((value) { setState(() {});});
      }));
  }
}