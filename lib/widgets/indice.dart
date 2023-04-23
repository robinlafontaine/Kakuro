import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'dart:math' as math;

class Indice extends StatelessWidget{
  final int indiceLigne, indiceColonne;
  final double taille;
  final bool last;

  Indice(this.indiceLigne,this.indiceColonne, this.taille, this.last);


  @override
  Widget build(BuildContext context) {
    if(indiceLigne!=0 && indiceColonne!=0)
      return Container(
        margin: last?null:EdgeInsets.only(right: 2),
        width: taille,
        height: taille,
        decoration: BoxDecoration(
            color: config.colors.caseColor
        ),
        child: Stack(
          children: [
            Center(
              child: Transform.rotate(
                  angle: 3*math.pi / 4,
                  child: Container(
                    width: taille/30,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black
                    ),
                  ),
              )
            ),
            Positioned(
              right: 2,
              child: Text(indiceLigne.toString(),
                style: TextStyle(
                    fontSize: taille*0.35
                ),),
            ),
            Positioned(
              bottom: 0,
              left: 2,
              child: Text(indiceColonne.toString(),
                style: TextStyle(
                    fontSize: taille*0.35
                ),),
            ),
          ]
        ),
      );
    else
      if(indiceLigne!=0)
        return Container(
          margin: last?null:EdgeInsets.only(right: 2),
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipLigne(taille),
                child: Container(
                  width: taille,
                  height: taille,
                  decoration: BoxDecoration(
                      color: config.colors.caseColor
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Text(indiceLigne.toString(),
                  style: TextStyle(
                      fontSize: taille*0.35
                  ),),
              ),
            ]
          ),
        );
      else
        return Container(
          margin: last?null:EdgeInsets.only(right: 2),
          child: Stack(
            children:[
              ClipPath(
                clipper: ClipColonne(taille),
                child: Container(
                  width: taille,
                  height: taille,
                  decoration: BoxDecoration(
                      color: config.colors.caseColor
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                left: 2,
                child: Text(indiceColonne.toString(),
                  style: TextStyle(
                    fontSize: taille*0.35
                  ),),
              ),
            ]
            ),
        );
  }
}

class ClipColonne extends CustomClipper<Path>{
  final taille;
  ClipColonne(this.taille);

  @override
  Path getClip(Size size) {
    Path path=Path();
    path.lineTo(0, taille);
    path.lineTo(taille, taille);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class ClipLigne extends CustomClipper<Path>{
  final taille;
  ClipLigne(this.taille);

  @override
  Path getClip(Size size) {
    Path path=Path();
    path.lineTo(taille, 0);
    path.lineTo(taille, taille);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}