import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/widgets/case.dart';
import 'package:kakuro/widgets/caseVide.dart';
import 'package:kakuro/widgets/indice.dart';

class scene extends StatefulWidget{
  final Kakuro kakuro;
  final Function maj;
  final List? base;

  const scene({super.key, required this.kakuro, required this.maj, this.base});


  @override State<scene> createState() => _sceneState(kakuro,maj);
}

class _sceneState extends State<scene>{
  Kakuro kakuro;
  Function maj;
  _sceneState(this.kakuro,this.maj);

  void initState(){
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width(context)/1.1)+2,
      height: (width(context)/1.1)+2,
      decoration: BoxDecoration(
        color: Colors.black
      ),
      child: Center(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(2),
            itemCount: kakuro.n,
            itemBuilder: (_,i){
             return Container(
                 margin: (i<kakuro.n-1)?EdgeInsets.only(bottom: 2):null,
                 child: Row(
                  children: <Widget>[
                    for(int j=0; j<kakuro.m-1;j++)
                      if(kakuro.entete.elementAt(i).elementAt(j).isNotEmpty)
                        Indice(
                            kakuro.entete.elementAt(i).elementAt(j).elementAt(0),
                            kakuro.entete.elementAt(i).elementAt(j).elementAt(1),
                            ((width(context)/1.1)/kakuro.m)-2,
                            false
                        )
                      else
                        if(kakuro.grille.elementAt(i).elementAt(j)==-1)
                          CaseVide(((width(context)/1.1)/kakuro.m)-2, false)
                        else
                          Case((widget.base==null)?0:widget.base![i][j],i, j, ((width(context)/1.1)/kakuro.m)-2, false, maj),
                    if(kakuro.entete.elementAt(i).elementAt(kakuro.m-1).isNotEmpty)
                      Indice(
                          kakuro.entete.elementAt(i).elementAt(kakuro.m-1).elementAt(0),
                          kakuro.entete.elementAt(i).elementAt(kakuro.m-1).elementAt(1),
                          ((width(context)/1.1)/kakuro.m)-2,
                          true
                      )
                    else
                      if(kakuro.grille.elementAt(i).elementAt(kakuro.m-1)==-1)
                        CaseVide(((width(context)/1.1)/kakuro.m)-2, true)
                      else
                        Case((widget.base==null)?0:widget.base![i][kakuro.m-1],i, kakuro.m-1, ((width(context)/1.1)/kakuro.m)-2, true, maj),
                  ],
                 ),
             );
            }),
      )
    );
  }
}