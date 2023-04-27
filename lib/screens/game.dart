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
  final bool online;

  game(this.kakuro,this.online);

  @override State<game> createState() => _gameState(kakuro);
}

class _gameState extends State<game> {
  Kakuro kakuro;
  List grille=[];
  _gameState(this.kakuro);

  void initState(){
    grille = kakuro.getBase();
    print(kakuro.grille);
  }

  bool testValide(){
    for(int i=0;i<kakuro.n;i++){
      for(int j=0;j<kakuro.m;j++){
        if(grille[i][j]!=kakuro.grille[i][j]){
          return false;
        }
      }
    }
  return true;
  }

  void maj(int i,int j,int valeur){
    this.grille[i][j] = valeur;
  }

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
          child: appbar(home:false,enjeu:true,retour:this.retour, enligne: widget.online,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height(context)/10,
            ),
            Center(
              child: scene(kakuro,maj),
            ),
            SizedBox(
              height: 30,
            ),
            boutton(
                value: "VALIDER",
                onPress: (){
                  testValide();
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(10,widget.online),
    );
  }


}