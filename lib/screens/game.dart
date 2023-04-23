import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';

class game extends StatefulWidget{
  final Kakuro kakuro;

  game(this.kakuro);

  @override State<game> createState() => _gameState(kakuro);
}

class _gameState extends State<game> {
  Kakuro kakuro;
  _gameState(this.kakuro);

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
          child: appbar(false,true,this.retour),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height(context)/10,
            ),
            Center(
              child: scene(kakuro),
            ),
            SizedBox(
              height: 30,
            ),
            boutton(
                value: "VALIDER",
                onPress: ()=>{}
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(0),
    );
  }


}