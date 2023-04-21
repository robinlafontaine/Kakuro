import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';

class CaseVide extends StatelessWidget{
  final double taille;
  final bool last;

  CaseVide(this.taille,this.last);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: last?EdgeInsets.only(right: 0):EdgeInsets.only(right: 2),
      width: taille,
      height: taille,
      decoration: BoxDecoration(
          color: Colors.black
      ),
    );
  }
}

