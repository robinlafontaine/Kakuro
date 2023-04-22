import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/config/config.dart';

class Case extends StatefulWidget{
  final int valeur;
  final int ligne;
  final int colonne;
  final double taille;
  final bool last;

  Case(this.valeur,this.ligne, this.colonne, this.taille, this.last);

  @override State<Case> createState() => _caseState(valeur,ligne,colonne, taille);

}

class _caseState extends State<Case>{
  int ligne,colonne;
  double taille;
  int valeur;
  _caseState(this.valeur,this.ligne,this.colonne, this.taille);

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
        margin: widget.last?null:EdgeInsets.only(right: 2),
        width: taille,
        height: taille,
        decoration: BoxDecoration(
          color: config.colors.caseColor
        ),
        child: Center(
          child: (valeur==0)?null:
          Text(valeur.toString(),
          style: TextStyle(
            fontSize: taille*0.5,
            color: Colors.red
          ),),
        ),
      ),
      onTap: add
    );
  }
}

