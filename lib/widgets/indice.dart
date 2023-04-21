import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';

class Indice extends StatelessWidget{
  final int indiceLigne, indiceColonne;
  final double taille;
  final bool last;

  Indice(this.indiceLigne,this.indiceColonne, this.taille, this.last);


  @override
  Widget build(BuildContext context) {
    if(indiceLigne!=0 && indiceColonne!=0)
      return Container(
        margin: last?EdgeInsets.only(right: 0):EdgeInsets.only(right: 2),
        width: taille,
        height: taille,
        decoration: BoxDecoration(
            color: config.colors.caseColor
        ),
        child: Stack(
          children: [
            Positioned(
              top: 3,
              right: 3,
              child: Text(indiceLigne.toString(),),
            ),
            Positioned(
              bottom: 3,
              left: 3,
              child: Text(indiceColonne.toString(),),
            ),
          ]
        ),
      );
    else
      if(indiceLigne!=0)
        return Container(
          margin: last?EdgeInsets.only(right: 0):EdgeInsets.only(right: 2),
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
                top: 3,
                right: 3,
                child: Text(indiceLigne.toString(),),
              ),
            ]
          ),
        );
      else
        return Container(
          margin: last?EdgeInsets.only(right: 0):EdgeInsets.only(right: 2),
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
                bottom: 3,
                left: 3,
                child: Text(indiceColonne.toString(),),
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
    // TODO: implement shouldReclip
    throw UnimplementedError();
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
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }

}