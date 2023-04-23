import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/widgets/boutton.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class horsligne extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(true,false,()=>{}),
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
                onPress: (){route(context, nouvellepartie());}
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
                value: "STATISTIQUES",
                onPress: (){}
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(0),
    );
  }

}