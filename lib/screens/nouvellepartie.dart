import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class nouvellepartie extends StatefulWidget{

  @override
  State<nouvellepartie> createState() => nouvellepartieState();

}

class nouvellepartieState extends State<nouvellepartie>{
  String ligne="4",colonne="4",diff="1";
  var items = ["4","5","6","7","8","9","10","11",
  ];
  var difficulte = ["1","2","3","4","5","6","7","8","9","10"];

  void initState(){
    super.initState();
    ligne = items[0];
    colonne = items[0];
    diff = difficulte[0];
  }

  void retour(){
    route(context, (config.online)?enligne():horsligne());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        retour();
        return true;
      },
      child: Scaffold(
        backgroundColor: config.colors.primaryBackground,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, width(context)/6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: appbar(home:false,enjeu:false,retour: retour),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height(context)/10,
                  ),
                  Text("Taille de la grille",
                    style: TextStyle(
                        fontSize: width(context)/21,
                        fontWeight: FontWeight.w600,
                        color: config.colors.primaryTitreSelect
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: config.colors.primarySelect
                        ),
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              dropdownColor: config.colors.primarySelectItem,
                            value: ligne,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: config.colors.primaryTextBlack,
                            ),
                            items: items.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Container(
                                  child: Text(
                                      items,
                                      style: TextStyle(
                                        color: config.colors.primaryTextBlack
                                      ),
                                  ),
                                  width: width(context)/4,),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                value == null?"":
                                ligne = value;
                              });
                            }
                          ),
                        ),
                      ),
                      FaIcon(FontAwesomeIcons.close,
                          size: width(context)/20,
                          color: config.colors.primaryTitreSelect
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: config.colors.primarySelect
                        ),
                        padding: EdgeInsets.only(left: 15,right: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              dropdownColor: config.colors.primarySelectItem,
                              value: colonne,
                              icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color:config.colors.primaryTextBlack
                              ),
                              items: items.map((items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Container(
                                      child: Text(
                                        items,style: TextStyle(
                                          color: config.colors.primaryTextBlack
                                        ),
                                      ), width: width(context)/4,)
                                );
                              }).toList(),
                              onChanged: (value){
                                setState(() {
                                  value == null?"":
                                  colonne = value;
                                });
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text("Niveau de difficulté",
                    style: TextStyle(
                        fontSize: width(context)/21,
                        fontWeight: FontWeight.w600,
                        color: config.colors.primaryTitreSelect
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: width(context)/1.1,
                    decoration: BoxDecoration(
                        color: config.colors.primarySelect
                    ),
                    padding: EdgeInsets.only(left: 15,right: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: config.colors.primarySelectItem,
                          value: diff,
                          icon: Icon(Icons.keyboard_arrow_down,color: config.colors.primaryTextBlack,),
                          items: difficulte.map((items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Container(
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                      color: config.colors.primaryTextBlack
                                    ),
                                  ),
                                )
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              value == null?"":
                              diff = value;
                            });
                          }
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  boutton(
                      value: "LANCER LA PARTIE",
                      onPress: (){
                        config.newgame=true;
                        route(context,
                            game(kakuro :Kakuro(
                                int.parse(ligne)-1,
                                int.parse(colonne)-1,
                                int.parse(diff)
                            ),
                            )
                        );
                      }
                  )
                ]
              ),
            ),
          ),
          bottomNavigationBar: navbar(actif:1,reaload: (){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => parametre())).then((value) { setState(() {});});}
            )),
    );
  }

}