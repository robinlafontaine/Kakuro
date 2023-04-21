import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';

class Case extends StatefulWidget{
  final int ligne;
  final int colonne;
  final double taille;
  final bool last;

  Case(this.ligne, this.colonne, this.taille, this.last);

  @override State<Case> createState() => _caseState(ligne,colonne, taille);

}

class _caseState extends State<Case>{
  int ligne,colonne;
  double taille;
  int valeur=0;
  _caseState(this.ligne,this.colonne, this.taille);

  void add(){
    setState(() {
      if(valeur==9){
        valeur=1;
      }else{
        valeur+=1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: widget.last?EdgeInsets.only(right: 2):EdgeInsets.only(right: 0),
        width: taille,
        height: taille,
        decoration: BoxDecoration(
          color: Colors.white70
        ),
        child: Center(
          child: Text(valeur.toString()),
        ),
      ),
      onTap: add
    );
  }
}

