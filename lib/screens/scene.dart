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
    print(kakuro.indiceLigne.length);
    print(kakuro.indiceColonne.length);
    print(kakuro.indiceLigne);
    print(kakuro.indiceColonne);
    print(kakuro.grilleUpdated);
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
                      if(kakuro.indiceColonne[i][j]!=0 || kakuro.indiceLigne[i][j]!=0)
                        Indice(
                            kakuro.indiceLigne[i][j],
                            kakuro.indiceColonne[i][j],
                            ((width(context)/1.1)/kakuro.m)-2,
                            false
                        )
                      else
                        if(kakuro.grilleUpdated[i][j]==-1)
                          CaseVide(((width(context)/1.1)/kakuro.m)-2, false)
                        else
                          Case((widget.base==null)?0:widget.base![i][j],i, j, ((width(context)/1.1)/kakuro.m)-2, false, maj),
                    if(kakuro.indiceColonne[i][kakuro.m-1]!=0 || kakuro.indiceLigne[i][kakuro.m-1]!=0)
                      Indice(
                          kakuro.indiceLigne[i][kakuro.m-1],
                          kakuro.indiceColonne[i][kakuro.m-1],
                          ((width(context)/1.1)/kakuro.m)-2,
                          true
                      )
                    else
                      if(kakuro.grilleUpdated[i][kakuro.m-1]==-1)
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