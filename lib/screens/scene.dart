import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/widgets/case.dart';

class scene extends StatefulWidget{
  final Kakuro kakuro;

  scene(this.kakuro);

  @override State<scene> createState() => _sceneState(kakuro);

}

class _sceneState extends State<scene>{
  Kakuro kakuro;
  _sceneState(this.kakuro);


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
                 margin: EdgeInsets.only(bottom: 2),
                 child: Row(
                  children: <Widget>[
                    for(int j=0; j<kakuro.m-1;j++)
                      Case(i, j, ((width(context)/1.1)/kakuro.m)-2, true),
                    Case(i, kakuro.m, ((width(context)/1.1)/kakuro.m)-2, false),
                  ],
                 ),
             );
            }),
      )
    );
  }
}