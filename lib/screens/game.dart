import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/scene.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: scene(kakuro),
      ),
    );
  }


}