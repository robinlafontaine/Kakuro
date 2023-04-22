import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/navbar.dart';

class game extends StatefulWidget{
  final Kakuro kakuro;

  game(this.kakuro);

  @override State<game> createState() => _gameState(kakuro);
}

class _gameState extends State<game> {
  Kakuro kakuro;
  _gameState(this.kakuro);

  @override
  void initState(){
    kakuro.affiche();
    kakuro.afficheEntete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size(double.infinity, height(context)/12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(false,true),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Center(
              child: scene(kakuro),
            )
          ],
        ),
      ),
      bottomNavigationBar: navbar(0),
    );
  }


}